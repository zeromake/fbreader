/*
 * Copyright (C) 2004-2010 Geometer Plus <contact@geometerplus.com>
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

#ifndef __DOCBOOKPLUGIN_H__
#define __DOCBOOKPLUGIN_H__

#include "../FormatPlugin.h"

class DocBookPlugin : public FormatPlugin {

public:
	DocBookPlugin();
	~DocBookPlugin();
	bool providesMetaInfo() const;
	bool acceptsFile(const std::string &extension) const;
	std::string accepts() const;
	bool readMetaInfo(Book &book) const;
	bool readModel(BookModel &model) const;
};

inline DocBookPlugin::DocBookPlugin() {}
inline DocBookPlugin::~DocBookPlugin() {}
inline bool DocBookPlugin::providesMetaInfo() const { return true; }

#endif /* __DOCBOOKPLUGIN_H__ */
