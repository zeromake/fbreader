/*
 * Copyright (C) 2004-2010 Geometer Plus <contact@geometerplus.com>
 * Copyright (C) 2021 Slava Monich <slava.monich@jolla.com>
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

#ifndef __ZLTEXTHYPHENATOR_H__
#define __ZLTEXTHYPHENATOR_H__

#include <string>

#include <ZLUnicodeUtil.h>

class ZLTextWord;

class ZLTextHyphenationInfo {

private:
	ZLTextHyphenationInfo(int length);
	const ZLTextHyphenationInfo &operator = (const ZLTextHyphenationInfo &info);

public:
	ZLTextHyphenationInfo(const ZLTextHyphenationInfo &info) : myMask(info.myMask) { }
	~ZLTextHyphenationInfo() {}
	bool isHyphenationPossible(size_t position) const;
	
private:
	std::vector<unsigned char> myMask;

friend class ZLTextHyphenator;
};

class ZLTextHyphenator {

public:
	static ZLTextHyphenator &Instance();
	static void deleteInstance();
	
protected:
	ZLTextHyphenator() {}

public:
	virtual ~ZLTextHyphenator() {}

	virtual void load(const std::string &language) = 0;
	virtual void unload() = 0;
	virtual const std::string &language() const = 0;

	ZLTextHyphenationInfo info(const ZLTextWord &word) const;

protected:
	virtual void hyphenate(ZLUnicodeUtil::Ucs4String &ucs4String, std::vector<unsigned char> &mask, int length) const = 0;

protected:
	static ZLTextHyphenator *ourInstance;
};

inline ZLTextHyphenationInfo::ZLTextHyphenationInfo(int length) : myMask(length - 1, false) {
}

inline bool ZLTextHyphenationInfo::isHyphenationPossible(size_t position) const {
	return (position < myMask.size()) && myMask[position];
}

#endif /* __ZLTEXTHYPHENATOR_H__ */
