(function () {
	var activePanel = null;

	function debugRoot() {
		return document.getElementById('wheels-debugbar');
	}

	function syncPageInset() {
		var root = debugRoot();
		var html = document.documentElement;
		if (!html) return;
		var insetPx = '0px';
		if (root && !root.classList.contains('wdb-collapsed')) {
			var measured = root.offsetHeight;
			insetPx = (measured > 0 ? measured : 36) + 'px';
			html.classList.add('wdb-has-debugbar');
			html.classList.remove('wdb-debugbar-collapsed');
		} else if (root) {
			html.classList.add('wdb-has-debugbar');
			html.classList.add('wdb-debugbar-collapsed');
		}
		html.style.setProperty('--wdb-inset', insetPx);
	}

	function setCollapsed(collapsed, animate) {
		var root = debugRoot();
		if (!root) return;
		if (!animate) {
			root.classList.add('wdb-no-transition');
		}
		if (collapsed) {
			root.classList.add('wdb-collapsed');
		} else {
			root.classList.remove('wdb-collapsed');
		}
		var logo = root.querySelector('.wdb-logo');
		if (logo) {
			logo.title = collapsed ? 'Show Debug Bar' : 'Request Details';
		}
		if (!animate) {
			root.offsetWidth;
			root.classList.remove('wdb-no-transition');
		}
		syncPageInset();
		try {
			if (collapsed) {
				sessionStorage.setItem('wdb-hidden', '1');
			} else {
				sessionStorage.removeItem('wdb-hidden');
			}
		} catch (e) {}
	}

	window.wdbToggle = function (name) {
		var root = debugRoot();
		if (root && root.classList.contains('wdb-collapsed')) {
			return;
		}
		var panels = document.querySelectorAll('#wheels-debugbar .wdb-panel');
		var tabs = document.querySelectorAll('#wheels-debugbar .wdb-tab');
		if (activePanel === name) {
			wdbClosePanel();
			return;
		}
		for (var i = 0; i < panels.length; i++) panels[i].classList.remove('open');
		var p = document.getElementById('wdb-panel-' + name);
		if (p) p.classList.add('open');
		for (var j = 0; j < tabs.length; j++) tabs[j].classList.remove('active');
		var t = document.getElementById('wdb-tab-' + name);
		if (t) t.classList.add('active');
		activePanel = name;
	};
	window.wdbClosePanel = function () {
		var panels = document.querySelectorAll('#wheels-debugbar .wdb-panel');
		var tabs = document.querySelectorAll('#wheels-debugbar .wdb-tab');
		for (var i = 0; i < panels.length; i++) panels[i].classList.remove('open');
		for (var j = 0; j < tabs.length; j++) tabs[j].classList.remove('active');
		activePanel = null;
	};
	window.wdbLogoClick = function () {
		var root = debugRoot();
		if (root && root.classList.contains('wdb-collapsed')) {
			wdbRestore();
			return;
		}
		wdbToggle('request');
	};
	window.wdbMinimize = function () {
		wdbClosePanel();
		setCollapsed(true, true);
	};
	window.wdbRestore = function () {
		setCollapsed(false, true);
	};
	window.wdbEnvSwitch = function (el) {
		var target = el.getAttribute('data-wdb-reload');
		if (!target) return false;
		var pw = window.prompt('Enter the reload password to switch environments:');
		if (pw === null || pw === '') return false;
		window.location.href = target + '&password=' + encodeURIComponent(pw);
		return false;
	};
	try {
		if (sessionStorage.getItem('wdb-hidden') === '1') {
			wdbClosePanel();
			setCollapsed(true, false);
		} else {
			syncPageInset();
		}
	} catch (e) {
		syncPageInset();
	}
})();
