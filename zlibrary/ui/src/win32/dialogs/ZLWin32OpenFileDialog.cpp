#include <shlobj.h>
#include <shobjidl.h>
#include <shlwapi.h>

#include "ZLWin32OpenFileDialog.h"
#include <ZLDialogManager.h>
#include "../../../../core/src/win32/util/W32WCHARUtil.h"
#include "portable-file-dialogs.h"


ZLWin32OpenFileDialog::ZLWin32OpenFileDialog(
    ZLWin32ApplicationWindow &window,
    const ZLResourceKey &resourceKey,
    const std::string &filePath): myWindow(window),
    myResourceKey(resourceKey),
    myFilePath(filePath) {
}

ZLWin32OpenFileDialog::~ZLWin32OpenFileDialog() {}



char* wToUtf8(const void *buffer, int bufferlen) {
	int len = WideCharToMultiByte(CP_UTF8, 0, (const wchar_t *)buffer, bufferlen, NULL, 0, NULL, NULL);
	auto block = (char *)malloc((len + 1) * sizeof(char));
	WideCharToMultiByte(CP_UTF8, 0, (const wchar_t *)buffer, bufferlen, (LPSTR)block, len, NULL, NULL);
	return block;
}

bool ZLWin32OpenFileDialog::run() {
    auto f = pfd::open_file(
        "Choose files to read",
        pfd::path::home(),
        
        {
            "Text Files (.txt .text)",
            "*.txt *.text",
            "All Files",
            "*"},
        pfd::opt::none);
    for (auto const &name : f.result()) {
        selectFilePath = name;
    }
    return true;
}

std::string ZLWin32OpenFileDialog::filePath() const {
    return selectFilePath;
}

std::string ZLWin32OpenFileDialog::directoryPath() const {
    auto i = selectFilePath.find_last_of("/\\");
    if (i != std::string::npos) {
        return selectFilePath.substr(0, i);
    }
    return selectFilePath;
}
