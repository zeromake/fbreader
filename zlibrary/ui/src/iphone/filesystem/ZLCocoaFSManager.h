/*
 * Copyright (C) 2010 Geometer Plus <contact@geometerplus.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
 * 02110-1301, USA.
 */

#ifndef __ZLCOCOAFSMANAGER_H__
#define __ZLCOCOAFSMANAGER_H__

#include "../../../../core/src/unix/filesystem/ZLUnixFSManager.h"

class ZLCocoaFSManager : public ZLUnixFSManager {

public:
	static void createInstance() { ourInstance = new ZLCocoaFSManager(); }
	
private:
	ZLCocoaFSManager() {}
	
protected:
	void normalize(std::string &path) const;
	std::string convertFilenameToUtf8(const std::string &name) const;
	std::string mimeType(const std::string &path) const;
};

#endif /* __ZLCOCOAFSMANAGER_H__ */
