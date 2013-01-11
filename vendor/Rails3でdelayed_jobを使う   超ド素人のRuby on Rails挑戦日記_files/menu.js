function Browser() {

  var ua, s, i;

  this.isIE    = false;  // Internet Explorer
  this.isNS    = false;  // Netscape
  this.version = null;

  ua = navigator.userAgent;

  s = "MSIE";
  if ((i = ua.indexOf(s)) >= 0) {
    this.isIE = true;
    this.version = parseFloat(ua.substr(i + s.length));
    return;
  }

  s = "Netscape6/";
  if ((i = ua.indexOf(s)) >= 0) {
    this.isNS = true;
    this.version = parseFloat(ua.substr(i + s.length));
    return;
  }

  // Treat any other "Gecko" browser as NS 6.1.

  s = "Safari";
  if ((i = ua.indexOf(s)) >= 0) {
    this.isSA = true;
    this.version = 1.0;
    return;
  }

  s = "Gecko";
  if ((i = ua.indexOf(s)) >= 0) {
    this.isNS = true;
    this.version = 6.1;
    return;
  }

}

var browser = new Browser();

var activeButton = null;

if (browser.isIE)
  document.onmousedown = pageMousedown;
else
  document.addEventListener("mousedown", pageMousedown, true);




function pageMousedown(event) {

  var el;

  if (activeButton == null)
    return;

  if (browser.isIE)
    el = window.event.srcElement;
  else
    el = (event.target.tagName ? event.target : event.target.parentNode);

  if (el == activeButton)
    return;

  if (getContainerWith(el, "DIV", "MENU") == null) {
    resetButton(activeButton);
    activeButton = null;
  }
}


function buttonClick(event, menuId) {

  var button;

  if (browser.isIE)
    button = window.event.srcElement;
  else
    button = event.currentTarget;

  button.blur();

  if (button.menu == null) {
    button.menu = document.getElementById(menuId);
    if (button.menu.isInitialized == null)
      menuInit(button.menu);
  }

  if (activeButton != null)
    resetButton(activeButton);

  if (button != activeButton) {
    depressButton(button);
    activeButton = button;
  }
  else
    activeButton = null;

  return false;
}

function buttonMouseover(event, menuId) {

  var button;

  // Find the target button element.

  if (browser.isIE)
    button = window.event.srcElement;
  else
    button = event.currentTarget;

  // If any other button menu is active, make this one active instead.

  if (activeButton != null && activeButton != button)
    buttonClick(event, menuId);
}

function depressButton(button) {

  var x, y;

  x = getPageOffsetLeft(button);
  y = getPageOffsetTop(button) + button.offsetHeight;
  if (browser.isSA){
		y -=5;
	}
  button.menu.style.left = x + "px";
  button.menu.style.top  = y + "px";
  button.menu.style.visibility = "visible";
}




function resetButton(button) {

//  removeClassName(button, "MENUBUTTONACTIVE");

  if (button.menu != null) {
    closeSubMenu(button.menu);
    button.menu.style.visibility = "hidden";
  }
}

function menuMouseover(event) {

  var menu;

  // Find the target menu element.

  if (browser.isIE)
    menu = getContainerWith(window.event.srcElement, "DIV", "menu");
  else
    menu = event.currentTarget;

  // Close any active sub menu.

  if (menu.activeItem != null)
    closeSubMenu(menu);
}


function menuItemMouseover(event, menuId) {

  var item, menu, x, y;

  if (browser.isIE)
    item = getContainerWith(window.event.srcElement, "A", "MENUITEM");
  else
    item = event.currentTarget;
  menu = getContainerWith(item, "DIV", "MENU");

  if (menu.activeItem != null)
    closeSubMenu(menu);
  menu.activeItem = item;

//  item.className += " MENUITEMHIGHLIGHT";

  if (item.subMenu == null) {
    item.subMenu = document.getElementById(menuId);
    if (item.subMenu.isInitialized == null)
      menuInit(item.subMenu);
  }

  x = getPageOffsetLeft(item) + item.offsetWidth;
  y = getPageOffsetTop(item)-3.0;

  var maxX, maxY;

  if (browser.isNS) {
    maxX = window.scrollX + window.innerWidth;
    maxY = window.scrollY + window.innerHeight;
  }
  if (browser.isIE) {
    maxX = (document.documentElement.scrollLeft   != 0 ? document.documentElement.scrollLeft   : document.body.scrollLeft)
         + (document.documentElement.clientWidth  != 0 ? document.documentElement.clientWidth  : document.body.clientWidth);
    maxY = (document.documentElement.scrollTop    != 0 ? document.documentElement.scrollTop    : document.body.scrollTop)
         + (document.documentElement.clientHeight != 0 ? document.documentElement.clientHeight : document.body.clientHeight);
  }
  if (browser.isSA) {
    maxX = window.scrollX + window.innerWidth;
    maxY = window.scrollY + window.innerHeight ;
  }

  maxX -= item.subMenu.offsetWidth;
  maxY -= item.subMenu.offsetHeight;

  if (x > maxX)
    x = Math.max(0, x - item.offsetWidth - item.subMenu.offsetWidth
      + (menu.offsetWidth - item.offsetWidth));
  y = Math.max(0, Math.min(y, maxY));
  if (browser.isSA) {
    item.subMenu.style.left = (x) + "px";
    item.subMenu.style.top  = (y) + "px";
  }else{
    item.subMenu.style.left = x + "px";
    item.subMenu.style.top  = y + "px";
  }
  item.subMenu.style.visibility = "visible";

  if (browser.isIE)
    window.event.cancelBubble = true;
  else
    event.stopPropagation();
}




function closeSubMenu(menu) {

  if (menu == null || menu.activeItem == null)
    return;

  if (menu.activeItem.subMenu != null) {
    closeSubMenu(menu.activeItem.subMenu);
    menu.activeItem.subMenu.style.visibility = "hidden";
    menu.activeItem.subMenu = null;
  }
//  removeClassName(menu.activeItem, "MENUITEMHIGHLIGHT");
  menu.activeItem = null;
}




function menuInit(menu) {

  var itemList, spanList;
  var textEl, arrowEl;
  var itemWidth;
  var w, dw;
  var i, j;

  if (browser.isIE) {
    menu.style.lineHeight = "2.5ex";
    spanList = menu.getElementsByTagName("SPAN");
    for (i = 0; i < spanList.length; i++)
      if (hasClassName(spanList[i], "MENUITEMARROW")) {
        spanList[i].style.fontFamily = "Webdings";
        spanList[i].firstChild.nodeValue = "4";
      }
  }

  itemList = menu.getElementsByTagName("A");
  if (itemList.length > 0)
    itemWidth = itemList[0].offsetWidth;
  else
    return;

  for (i = 0; i < itemList.length; i++) {
    spanList = itemList[i].getElementsByTagName("SPAN");
    textEl  = null;
    arrowEl = null;
    for (j = 0; j < spanList.length; j++) {
      if (hasClassName(spanList[j], "MENUITEMTEXT"))
        textEl = spanList[j];
      if (hasClassName(spanList[j], "MENUITEMARROW"))
        arrowEl = spanList[j];
    }
    if (textEl != null && arrowEl != null)
      textEl.style.paddingRight = (itemWidth 
        - (textEl.offsetWidth + arrowEl.offsetWidth)) + "px";
  }

  if (browser.isIE) {
    w = itemList[0].offsetWidth;
    itemList[0].style.width = w + "px";
    dw = itemList[0].offsetWidth - w;
    w -= dw;
    itemList[0].style.width = w + "px";
  }
  menu.isInitialized = true;
}




function getContainerWith(node, tagName, className) {

  while (node != null) {
    if (node.tagName != null && node.tagName == tagName &&
        hasClassName(node, className))
      return node;
    node = node.parentNode;
  }

  return node;
}




function hasClassName(el, name) {

  var i, list;

  list = el.className.split(" ");
  for (i = 0; i < list.length; i++)
    if (list[i] == name)
      return true;

  return false;
}




function removeClassName(el, name) {

  var i, curList, newList;

  if (el.className == null)
    return;

  newList = new Array();
  curList = el.className.split(" ");
  for (i = 0; i < curList.length; i++)
    if (curList[i] != name)
      newList.push(curList[i]);
  el.className = newList.join(" ");
}





function getPageOffsetLeft(el) {

  var x;

  x = el.offsetLeft;
  if (el.offsetParent != null)
    x += getPageOffsetLeft(el.offsetParent)+0.5;

  return x;
}




function getPageOffsetTop(el) {

  var y;

  y = el.offsetTop;
  if (el.offsetParent != null)
    y += getPageOffsetTop(el.offsetParent);

  return y;
}

