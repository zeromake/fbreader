#ifndef __ZLWIN32OPENFILEDIALOG_H__
#define __ZLWIN32OPENFILEDIALOG_H__

#include <vector>
#include <map>
#include <windows.h>

#include <ZLOpenFileDialog.h>
#include "../application/ZLWin32ApplicationWindow.h"


class ZLWin32OpenFileDialog: public ZLOpenFileDialog {
public:
    ZLWin32OpenFileDialog(
        ZLWin32ApplicationWindow &window,
        const std::string &title,
        const std::string &dir,
        const ZLOpenFileDialog::Filter &filter);
    ~ZLWin32OpenFileDialog();
	bool run();
    std::string directoryPath()const;
    std::string filePath()const;
private:
	ZLWin32ApplicationWindow &myWindow;
    const std::string &myTitle;
    const std::string &myDir;
    const ZLOpenFileDialog::Filter &myFilter;
    std::string selectFilePath;
    std::string selectDirPath;
};


#endif
