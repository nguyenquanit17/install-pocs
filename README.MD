
https://raw.githubusercontent.com/nguyenquanit17/install-pocs/master/install.sh

curl -s https://raw.githubusercontent.com/nguyenquanit17/install-pocs/refs/heads/master/install.sh | bash

//------------------------------------

curl -L https://yourhost.com/download.sh | bash -s "1fcFXZllDk4gS-NmuTpIi4OXcT_NONjc7"

curl -L https://yourhost.com/download.sh | bash -s "1fcFXZllDk4gS-NmuTpIi4OXcT_NONjc7|1fcFXZllDk4gS-NmuTpIi4OXcT_NONjc8|1fcFXZllDk4gS-NmuTpIi4OXcT_NONjc9"


curl -L https://raw.githubusercontent.com/nguyenquanit17/install-pocs/master/install.sh | bash -s "1ZflJ3sPZFFFWiEdjyxSlqcg5V3qSckx_"


curl -L https://raw.githubusercontent.com/nguyenquanit17/install-pocs/master/download.sh | bash -s "1heRROGNieaemcvz42VnDME7rkDnXMY8r"


https://drive.google.com/file/d/`<ID>`/view?usp=drive_link

zip -e install.zip winlator.apk "Yugioh! Power of Chaos - 3 in 1 Winlator - Pass gamiQ.zip"

# Flow khi user chạy

User chỉ cần:

<pre class="overflow-visible! px-0!" data-start="1951" data-end="2001"><div class="relative w-full my-4"><div class=""><div class="relative"><div class="h-full min-h-0 min-w-0"><div class="h-full min-h-0 min-w-0"><div class="border border-token-border-light border-radius-3xl corner-superellipse/1.1 rounded-3xl"><div class="h-full w-full border-radius-3xl bg-token-bg-elevated-secondary corner-superellipse/1.1 overflow-clip rounded-3xl lxnfua_clipPathFallback"><div class="pointer-events-none absolute inset-x-4 top-12 bottom-4"><div class="pointer-events-none sticky z-40 shrink-0 z-1!"><div class="sticky bg-token-border-light"></div></div></div><div class=""><div class="relative z-0 flex max-w-full"><div id="code-block-viewer" dir="ltr" class="q9tKkq_viewer cm-editor z-10 light:cm-light dark:cm-light flex h-full w-full flex-col items-stretch ͼk ͼy"><div class="cm-scroller"><div class="cm-content q9tKkq_readonly"><span>1. Cài Termux</span><br/><span>2. Mở Termux</span><br/><span>3. Paste 1 dòng</span></div></div></div></div></div></div></div></div></div><div class=""><div class=""></div></div></div></div></div></pre>

<pre class="overflow-visible! px-0!" data-start="2003" data-end="2053"><div class="relative w-full my-4"><div class=""><div class="relative"><div class="h-full min-h-0 min-w-0"><div class="h-full min-h-0 min-w-0"><div class="border border-token-border-light border-radius-3xl corner-superellipse/1.1 rounded-3xl"><div class="h-full w-full border-radius-3xl bg-token-bg-elevated-secondary corner-superellipse/1.1 overflow-clip rounded-3xl lxnfua_clipPathFallback"><div class="pointer-events-none absolute inset-x-4 top-12 bottom-4"><div class="pointer-events-none sticky z-40 shrink-0 z-1!"><div class="sticky bg-token-border-light"></div></div></div><div class=""><div class="relative z-0 flex max-w-full"><div id="code-block-viewer" dir="ltr" class="q9tKkq_viewer cm-editor z-10 light:cm-light dark:cm-light flex h-full w-full flex-col items-stretch ͼk ͼy"><div class="cm-scroller"><div class="cm-content q9tKkq_readonly"><span>curl -s https://yourlink/install.sh | bash</span></div></div></div></div></div></div></div></div></div><div class=""><div class=""></div></div></div></div></div></pre>

Script tự làm:

<pre class="overflow-visible! px-0!" data-start="2071" data-end="2208"><div class="relative w-full my-4"><div class=""><div class="relative"><div class="h-full min-h-0 min-w-0"><div class="h-full min-h-0 min-w-0"><div class="border border-token-border-light border-radius-3xl corner-superellipse/1.1 rounded-3xl"><div class="h-full w-full border-radius-3xl bg-token-bg-elevated-secondary corner-superellipse/1.1 overflow-clip rounded-3xl lxnfua_clipPathFallback"><div class="pointer-events-none absolute inset-x-4 top-12 bottom-4"><div class="pointer-events-none sticky z-40 shrink-0 z-1!"><div class="sticky bg-token-border-light"></div></div></div><div class=""><div class="relative z-0 flex max-w-full"><div id="code-block-viewer" dir="ltr" class="q9tKkq_viewer cm-editor z-10 light:cm-light dark:cm-light flex h-full w-full flex-col items-stretch ͼk ͼy"><div class="cm-scroller"><div class="cm-content q9tKkq_readonly"><span>install dependencies</span><br/><span>↓</span><br/><span>download install.zip</span><br/><span>↓</span><br/><span>unzip (password auto)</span><br/><span>↓</span><br/><span>extract game data</span><br/><span>↓</span><br/><span>open APK installer</span><br/><span>↓</span><br/><span>user press INSTALL</span></div></div></div></div></div></div></div></div></div><div class=""><div class=""></div></div></div></div></div></pre>

Rất dễ cho người  **không biết kỹ thuật** .

---

//------------------------------------
# Windows 10+ (tải + giải nén pass gamiQ, mỗi game 1 thư mục)

Double-click `windows/download-windows.bat`, hoặc dán vào PowerShell:

    irm https://raw.githubusercontent.com/nguyenquanit17/install-pocs/master/windows/download-windows.ps1 | iex

Tuỳ chọn: `-Dest D:\GamiQ` (mặc định hỏi, Enter = C:\GamiQ; đường dẫn phải không dấu), `-Games 3,5` / `all`,
`-Force` (tải lại game đã có), `-NoPause`. Danh sách game + Drive ID ở `$GameList` đầu script.
Zip 05/06 mã hoá AES ⇒ cần 7-Zip; máy chưa cài thì script tự tải 7za.exe portable vào `<Dest>\_tools\7zip`.
Tải đứt giữa chừng: chạy lại, curl tải tiếp từ `<Dest>\_downloads`.
