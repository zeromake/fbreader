#include <shlobj.h>
#include <shobjidl.h>
#include <shlwapi.h>

#include "ZLWin32OpenFileDialog.h"
#include <ZLDialogManager.h>
#include <ZLStringUtil.h>
#include "portable-file-dialogs.h"
#include "../../../../core/src/win32/util/W32WCHARUtil.h"


ZLWin32OpenFileDialog::ZLWin32OpenFileDialog(
    ZLWin32ApplicationWindow &window,
    const std::string &title,
    const std::string &dir,
    const ZLOpenFileDialog::Filter &filter):
    myWindow(window),
    myTitle(title),
    myDir(dir),
    myFilter(filter) {
}

ZLWin32OpenFileDialog::~ZLWin32OpenFileDialog() {}



char* wToUtf8(const void *buffer, int bufferlen) {
	int len = WideCharToMultiByte(CP_UTF8, 0, (const wchar_t *)buffer, bufferlen, NULL, 0, NULL, NULL);
	auto block = (char *)malloc((len + 1) * sizeof(char));
	WideCharToMultiByte(CP_UTF8, 0, (const wchar_t *)buffer, bufferlen, (LPSTR)block, len, NULL, NULL);
	return block;
}

bool ZLWin32OpenFileDialog::run() {
    auto filter = ZLStringUtil::join(myFilter.acceptsStr(), ";");
    auto f = pfd::open_file(
        myTitle.empty() ? "select book file": myTitle,
        myDir.empty() ? pfd::path::home() : myDir,
        {
            "ebook files "+ filter,
            filter,
            "all files (*)",
            "*"},
        pfd::opt::none);
    for (auto const &name : f.result()) {
        selectFilePath = name;
    }
    return !selectFilePath.empty();
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
