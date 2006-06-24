/*
 * Copyright (C) 2004-2006 Nikolay Pultsin <geometer@mawhrin.net>
 * Copyright (C) 2005, 2006 Mikhail Sobolev <mss@mawhrin.net>
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

#ifndef __ZLAPPLICATION_H__
#define __ZLAPPLICATION_H__

#include <string>
#include <vector>
#include <map>

#include <abstract/shared_ptr.h>
#include <abstract/ZLOptions.h>

class ZLView;
class ZLViewWidget;

class ZLApplication {

public:
	ZLIntegerOption RotationAngleOption;
	ZLIntegerOption AngleStateOption;

public:

	class Action {

	public:
		virtual ~Action();
		virtual bool isVisible();
		virtual bool isEnabled();
		void checkAndRun();

	protected:
		virtual void run() = 0;
	};

protected:
	class RotationAction : public Action {

	public:
		RotationAction(ZLApplication &application);
		bool isVisible();
		void run();

	private:
		ZLApplication &myApplication;
	};
	friend class RotationAction;
	
public:

	class Toolbar {

	public:
		class Item {

		public:
			Item();
			virtual ~Item();

			virtual bool isButton() const = 0;
			bool isSeparator() const;

		friend class Toolbar;
		};
	
		class ButtonItem : public Item {

		public:
			ButtonItem(int actionId, const std::string &iconName);

			bool isButton() const;

			int actionId() const;
			const std::string &iconName() const;

		private:
			const int myActionId;
			const std::string myIconName;

		friend class Toolbar;
		};
	
		class SeparatorItem : public Item {

		public:
			bool isButton() const;
		};

	public:
		typedef shared_ptr<Item> ItemPtr;
		typedef std::vector<ItemPtr> ItemVector;

		void addButton(int actionId, const std::string &iconName);
		void addSeparator();

		const ItemVector &items() const;

	private:
		ItemVector myItems;

	friend class ZLApplication;
	};

	class Menu {

	public:
		class Item {

		public:
			enum ItemType {
				MENU_ITEM,
				SUBMENU_ITEM,
				SEPARATOR_ITEM
			};

			virtual ~Item();

			ItemType type() const;

		protected:
			Item(ItemType type);

		private:
			const ItemType myType;
		};

		typedef shared_ptr<Item> ItemPtr;
		typedef std::vector<ItemPtr> ItemVector;

		void addItem(const std::string &itemName, int actionId);
		void addSeparator();
		Menu& addSubmenu(const std::string &menuName);

		const ItemVector &items() const;

		virtual ~Menu();

	protected:
		Menu();

	private:
		ItemVector myItems;

	friend class ZLApplication;
	};

	class Menubar : public Menu {

	public:
		class MenuItem : public Menu::Item {

		public:
			MenuItem(const std::string &name, int actionId);

			const std::string &name() const;
			int actionId() const;

		private:
			const std::string myName;
			int myActionId;
		};

		class SubMenuItem : public Menu::Item, public Menu {

		public:
			SubMenuItem(const std::string &menuName);

			const std::string &menuName() const;

		private:
			const std::string myMenuName;
		};

		class SeparatorItem : public Menu::Item {

		public:
			SeparatorItem();
		};

	public:
		Menubar();

	friend class ZLApplication;
	};

protected:
	ZLApplication(const std::string &name);

	void addAction(int actionId, shared_ptr<Action> action);
	void setView(ZLView *view);
	ZLView *currentView();

	void initWindow(class ZLApplicationWindow *view);

	void resetWindowCaption();

public:
	// TODO: remove
	void repaintView();
	// TODO: remove
	virtual bool isRotationSupported() const = 0;

public:
	virtual ~ZLApplication();

	shared_ptr<Action> action(int actionId) const;
	bool isActionVisible(int actionId) const;
	bool isActionEnabled(int actionId) const;
	void doAction(int actionId);

	Toolbar &toolbar();
	Menubar &menubar();

	void refreshWindow();

private:
	std::string myName;

protected:
	ZLViewWidget *myViewWidget;

private:
	std::map<int,shared_ptr<Action> > myActionMap;
	Toolbar myToolbar;
	Menubar myMenubar;
	class ZLApplicationWindow *myWindow;
};

class ZLApplicationWindow {

protected:
	ZLApplicationWindow();

	const ZLApplication &application() const;

	void init();
	virtual void refresh() = 0;
	virtual void addToolbarItem(ZLApplication::Toolbar::ItemPtr item) = 0;
	// TODO: replace with abstract method when available for all platforms
	virtual void addMenubarItem(ZLApplication::Menubar::ItemPtr item) {}
	virtual void setCaption(const std::string &caption) = 0;

public:
	virtual ~ZLApplicationWindow();

private:
	ZLApplication *myApplication;

friend class ZLApplication;
};

inline ZLApplication::~ZLApplication() {
	if (myWindow != 0) {
		//delete myWindow;
	}
}
inline ZLApplication::Toolbar &ZLApplication::toolbar() { return myToolbar; }
inline ZLApplication::Menubar &ZLApplication::menubar() { return myMenubar; }

inline void ZLApplication::refreshWindow() {
	if (myWindow != 0) {
		myWindow->refresh();
	}
}

inline ZLApplicationWindow::ZLApplicationWindow() {}
inline ZLApplicationWindow::~ZLApplicationWindow() {}
inline const ZLApplication &ZLApplicationWindow::application() const { return *myApplication; }

inline const ZLApplication::Toolbar::ItemVector &ZLApplication::Toolbar::items() const { return myItems; }

inline ZLApplication::Toolbar::Item::Item() {}
inline ZLApplication::Toolbar::Item::~Item() {}
inline bool ZLApplication::Toolbar::Item::isSeparator() const { return !isButton(); }

inline ZLApplication::Toolbar::ButtonItem::ButtonItem(int actionId, const std::string &iconName) : myActionId(actionId), myIconName(iconName) {}
inline bool ZLApplication::Toolbar::ButtonItem::isButton() const { return true; }
inline int ZLApplication::Toolbar::ButtonItem::actionId() const { return myActionId; }
inline const std::string &ZLApplication::Toolbar::ButtonItem::iconName() const { return myIconName; }

inline bool ZLApplication::Toolbar::SeparatorItem::isButton() const { return false; }

inline ZLApplication::Menu::Menu() {}
inline ZLApplication::Menu::~Menu() {}
inline const ZLApplication::Menu::ItemVector &ZLApplication::Menu::items() const { return myItems; }

inline ZLApplication::Menu::Item::Item(ItemType type): myType(type) {}
inline ZLApplication::Menu::Item::~Item() {}
inline ZLApplication::Menu::Item::ItemType ZLApplication::Menubar::Item::type() const { return myType; }

inline ZLApplication::Menubar::Menubar() {}

inline ZLApplication::Menubar::MenuItem::MenuItem(const std::string& name, int actionId) : Item(MENU_ITEM), myName(name), myActionId(actionId) {}
inline const std::string& ZLApplication::Menubar::MenuItem::name() const { return myName; }
inline int ZLApplication::Menubar::MenuItem::actionId() const { return myActionId; }

inline ZLApplication::Menubar::SubMenuItem::SubMenuItem(const std::string &menuName) : Menu::Item(SUBMENU_ITEM), myMenuName(menuName) {}
inline const std::string &ZLApplication::Menubar::SubMenuItem::menuName() const { return myMenuName; }

inline ZLApplication::Menubar::SeparatorItem::SeparatorItem(void) : Item(SEPARATOR_ITEM) {}

#endif /* __ZLAPPLICATION_H__ */

// vim:noet:ts=2:sw=2