#include <ZLibrary.h>

#if defined(_WIN32)
#include <ZLWin32FSManager.h>
#else
#include <ZLUnixFSManager.h>
class ZLEmptyFSManager : public ZLUnixFSManager {
private:
	ZLEmptyFSManager() {};
protected:
	std::string convertFilenameToUtf8(const std::string &name) const{
        return name;
    };
	std::string mimeType(const std::string &path) const{
        return std::string();
    };
public:
	static void createInstance() { ourInstance = new ZLEmptyFSManager(); };
};

#endif

#if defined(_WIN32)
const std::string ZLibrary::FileNameDelimiter("\\");
#else
const std::string ZLibrary::FileNameDelimiter("/");
#endif

bool ZLibrary::init(int &argc, char **&argv) {
    #ifdef _WIN32
    ZLWin32FSManager::createInstance();
    #else
    ZLEmptyFSManager::createInstance();
    #endif
    return true;
}

void ZLibrary::initLocale() {
    ourLanguage = "es";
    ourCountry = "LA";
}
