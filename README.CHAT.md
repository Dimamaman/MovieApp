# Chat logikasi

Bu hujjat `ChatPage` (`lib/presentation/pages/chat/chat_page.dart`) va `ChatBloc` (`lib/application/chat/chat_bloc.dart`) asosida chat funksiyasining umumiy mantiqini tushuntiradi.

---

## 1. Umumiy arxitektura

- UI qismi: `ChatPage`
- Biznes logika / state: `ChatBloc`
- Transport:
    - HTTP / repository: `chatRepository`
    - Real-time: `WebSocketService`

---

## 2. ChatPage logikasi

### 2.1. Page ochilganda

- `initState` ichida:
    - `WebSocketService.connectWebSocket(context)` chaqiriladi (app qayta resume bo‘lganda ham).
    - `messageController` boshlang‘ich matn sifatida `widget.message` bilan to‘ldirilishi mumkin.
    - `scrollController`ga listener qo‘shiladi:
        - Scroll pastiga (oxiriga) yetganda:
            - Eski xabarlarni yuklash uchun `ChatEvent.getALlMessages` yuboriladi (`chatId` bilan, pagination).

### 2.2. Xabar yuborish oqimi

`sendMessage({int? chatId})`:

1. Agar `messageController.text.trim()` bo‘sh bo‘lmasa:
2. Agar parametrdan `chatId` kelsa:
    - `ChatEvent.sendMessage`:
        - `message: controller.text`
        - `chatId: widget.chatId ?? chatId`
        - `user: UserChatModel()`
    - So‘ng controller `clear()`.
3. Agar `widget.chatId == null` (yangi chat kerak):
    - `ChatEvent.createAndSendMessage` yuboriladi:
        - `orderId`, `displayId`, `role`, `message`, `onSuccess`.
    - `onSuccess` callback ichida:
        - Backenddan qaytgan `value.id` bilan yana `ChatEvent.sendMessage(create: true, chatId: value.id, user: value.user)` yuboriladi.
        - Controller `clear()`.
4. Aks holda (mavjud chat):
    - `ChatEvent.sendMessage`:
        - `chatId: widget.chatId ?? 0`
        - `user: widget.user ?? UserChatModel()`
    - Controller `clear()`.

### 2.3. Xabarlar ro‘yxatini ko‘rsatish

- `BlocBuilder<ChatBloc, ChatState>`:
    - Agar `state.isMessageLoading == true` → `Loading` widget.
    - Aks holda:
        - Agar `state.messages` bo‘sh emas → `_listMessage(state, colors)`.
        - Aks holda → “chat history is empty” ekrani.

- `_listMessage`:
    - `GroupedListView<MessageModel, DateTime>`:
        - Xabarlar sana bo‘yicha guruhlangan.
        - Har sanaga alohida separator (`Today` yoki `dd.MM` format).
        - Har xabar uchun `MessageItem`:
            - `edit`, `reply`, `delete` callbacklari bor (delete hozircha local emas).

### 2.4. Pastki panel (input yoki “conversation ended”)

- `BlocConsumer<ChatBloc, ChatState>`:
    - `listener`:
        - Agar:
            - `state.messages` bo‘sh,
            - `widget.role == "USER"`,
            - `widget.user == null`,
            - va `widget.message` bo‘sh bo‘lmasa:
                - `ChatEvent.getALlMessages(chatId: state.chat?.id)` yuboriladi.
                - Agar `messageController.text == widget.message` bo‘lsa → `clear()`.
    - `builder`:
        - Agar `widget.status` yoki `state.chat?.status` `3` yoki `4` bo‘lsa:
            - Pastda “Your conversation has ended” bloki.
            - “Send us a message” tugmasi:
                - `Navigator.pop`
                - `AppRoute.goChatPage(... active: true, role: 'USER', message: help ...)`
                - So‘ng `ChatEvent.getALlChats(isRefresh: true)`.
        - Aks holda:
            - `SendButton`:
                - `sendMessage` → `sendMessage(chatId: state.chat?.id)`
                - `sendImage` → `AppRoute.showChatImagePickerModal(...)`
                - `replyMessage` va `removeReplyMessage` bilan reply logikasi.

---

## 3. ChatBloc logikasi

`ChatBloc` `ChatEvent`larni qabul qiladi va `ChatState`ni yangilaydi.

### 3.1. Asosiy state maydonlar

- `chats`: chatlar ro‘yxati (`List<ChatModel>`)
- `messages`: joriy chat xabarlari (`List<MessageModel>`)
- `chat`: joriy tanlangan chat (`ChatModel?`)
- `isLoading`: chatlar ro‘yxatini yuklash holati
- `isMessageLoading`: xabarlarni birinchi yuklash yoki refresh holati
- `isRefreshLoading`: yuqoridan scroll qilib eski xabarlarni tortish holati
- `isButtonLoading`: yuborish tugmasi loading holati
- `count`: umumiy son (API’dan keladi)

### 3.2. Asosiy eventlar

#### GetALlChats

- Chatlar ro‘yxatini pagination bilan yuklaydi.
- `isRefresh == true` bo‘lsa:
    - `chats` bo‘shlanadi, `isLoading = true`, refresh controller reset.
- API: `chatRepository.getChatList(skip: state.chats.length, ...)`.
- Success:
    - Eski `chats` ustiga yangi `value.data` append qilinadi.
    - `isLoading = false`, `count` yangilanadi.
    - Refresh/load holatlari `SmartRefresher` controller orqali yangilanadi.
- Error:
    - `isLoading = false`, refresh/load failed + snackbar.

#### CreateAndSendMessage

- Yangi chatni yaratadi va UI’da darhol outgoing xabar qo‘shadi.
- `chatRepository.createChat(...)` chaqiriladi.
- Success:
    - `messages`ga:
        - `outgoing: true`, `message: event.message`, `chatId: value.id`, `createdAt: time` qo‘shiladi.
    - `chat` maydoni `ChatModel(id: value.id, user: value.user)` bilan set qilinadi.
    - `isButtonLoading = false`.
    - `event.onSuccess(value)` chaqiriladi (UI SendMessage yuborishi uchun).
- Error:
    - `isButtonLoading = false`.

#### GetALlMessages

- Xabarlarni chat bo‘yicha pagination bilan yuklaydi.
- Agar `event.chatId == null`:
    - `messages` bo‘sh, `chat = null`, `isMessageLoading = false`.
- Agar `isRefresh == true`:
    - `messages` bo‘sh, `isMessageLoading = true`, refresh controller reset.
- Aks holda:
    - `isRefreshLoading = true`.
- API: `chatRepository.getMessageList(skip: state.messages.length, chatId: event.chatId)`.
- Success:
    - Eski `messages` ustiga `value.data` qo‘shiladi.
    - `chat` bo‘sh bo‘lsa, `ChatModel(id: event.chatId)` bilan to‘ldiriladi.
    - `isMessageLoading = false`, `isRefreshLoading = false`, `count` yangilanadi.
    - Refresh/load holatlari controller orqali boshqariladi.
- Error:
    - `isMessageLoading = false`, `isRefreshLoading = false`, refresh/load failed + snackbar.

#### SendMessage

- Oddiy xabar yuborish.
- Zarur bo‘lsa:
    - `AssetEntity` → `File` yoki `imagePath` → `File`.
- `chatRepository.sendMessage(chatId, content, filePath)` chaqiriladi.
- Success:
    - Agar `event.create == true`:
        - Faqat `isButtonLoading = false`, xabar ro‘yxatiga qo‘shmaydi.
    - Aks holda:
        - Serverdan kelgan xabar `messages`ga:
            - `outgoing: true`, `chatId: event.chatId`, `createdAt: now` qilib qo‘shiladi.
        - `isButtonLoading = false`.
- Error:
    - `isButtonLoading = false`, snackbar.

#### ChangeStatus

- Agar `state.chat?.id == event.chatId`:
    - `chat.status`ni `event.status`ga yangilaydi.

#### AddMessage

- WebSocket orqali kelgan yangi xabarlar.
- Agar `state.chat?.id == event.message.chatId`:
    - `messages`ga shu xabarni qo‘shadi.
- Bu real-time yangilanish uchun.

#### EditMessage / DeleteMessage

- `chatRepository.editMessage` va `chatRepository.deleteMessage` chaqiriladi.
- Hozircha lokal ro‘yxatni o‘zgartirmaydi (server taraf hal qiladi).

#### SearchChat

- Ma’lum `orderId` / `orderDisplayId` bo‘yicha chatni topadi.
- `messages` bo‘shlanadi, `chat = null`, `isMessageLoading = true`.
- `chatRepository.getChatList(orderId: event.orderId, active: event.active)` chaqiriladi.
- Success:
    - `value.data` ichidan:
        - `element.subject == "${event.orderDisplayId}"` bo‘lgan chat qidiriladi.
    - Topilsa:
        - `chat` = `chats.first`.
        - `event.onChatFound?.call(chats.first.id)`.
    - `isMessageLoading = false`.
- Error:
    - `isMessageLoading = false`, snackbar.

#### MakeSeenMyMessages

- Lokal tarafda xabarlarni `seen: true` qilish.
- `messages` map qilinadi:
    - Agar `e.chatId == event.chatId` → `e.copyWith(seen: true)`.
- Bu UI ko‘rinishidagi “seen” statusini yangilash uchun, serverga alohida request ko‘rinmaydi.

---

## 4. Umumiy oqim

1. Foydalanuvchi `ChatPage`ga kiradi → WebSocket ulanadi.
2. Mavjud chatga kirilsa, xabarlar `GetALlMessages` orqali yuklanadi (scroll bilan eski xabarlar).
3. Foydalanuvchi xabar yuboradi:
    - Agar chat mavjud bo‘lsa → bevosita `SendMessage`.
    - Agar chat mavjud bo‘lmasa → `CreateAndSendMessage` → so‘ng `SendMessage`.
4. WebSocket orqali yangi xabarlar keladi → `AddMessage` orqali `messages` ro‘yxatiga qo‘shiladi.
5. Chat/order statusi `3` yoki `4` bo‘lsa → conversation tugagan ekran ko‘rinadi va yangi support chat ochish imkoniyati beriladi.