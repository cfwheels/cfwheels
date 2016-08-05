<cfscript>

	/**
	* PUBLIC CONTROLLER REQUEST FUNCTIONS
	*/

	public any function flash(string key) {
		var loc = {};
		loc.flash = $readFlash();
		if (StructKeyExists(arguments, "key")) {
			if (flashKeyExists(key=arguments.key)) {
				loc.flash = loc.flash[arguments.key];
			} else {
				loc.flash = "";
			}
		}
		// we can just return the flash since it is created at the beginning of the request
		// this way we always return what is expected - a struct
		loc.rv = loc.flash;
		return loc.rv;
	}

	public void function flashClear() {
		$writeFlash();
	}

	public numeric function flashCount() {
		var loc = {};
		loc.flash = $readFlash();
		loc.rv = StructCount(loc.flash);
		return loc.rv;
	}

	public any function flashDelete(required string key) {
		var loc = {};
		loc.flash = $readFlash();
		loc.rv = StructDelete(loc.flash, arguments.key, true);
		$writeFlash(loc.flash);
		return loc.rv;
	}

	public void function flashInsert() {
		var loc = {};
		loc.flash = $readFlash();
		for (loc.key in arguments) {
			StructInsert(loc.flash, loc.key, arguments[loc.key], true);
		}
		$writeFlash(loc.flash);
	}

	public boolean function flashIsEmpty() {
		var loc = {};
		if (flashCount()) {
			loc.rv = false;
		} else {
			loc.rv = true;
		}
		return loc.rv;
	}


	public void function flashKeep(string key="") {
		$args(args=arguments, name="flashKeep", combine="key/keys");
		request.wheels.flashKeep = arguments.key;
	}

	public boolean function flashKeyExists(required string key) {
		var loc = {};
		loc.flash = $readFlash();
		loc.rv = StructKeyExists(loc.flash, arguments.key);
		return loc.rv;
	}

	/**
	* PRIVATE FUNCTIONS
	*/

	public struct function $readFlash() {
		var loc = {};
		loc.rv = {};
		if (!StructKeyExists(arguments, "$locked")) {
			loc.lockName = "flashLock" & application.applicationName;
			loc.rv = $simpleLock(name=loc.lockName, type="readonly", execute="$readFlash", executeArgs=arguments);
		} else if ($getFlashStorage() == "cookie" && StructKeyExists(cookie, "flash")) {
			loc.rv = DeSerializeJSON(cookie.flash);
		} else if ($getFlashStorage() == "session" && StructKeyExists(session, "flash")) {
			loc.rv = Duplicate(session.flash);
		}
		return loc.rv;
	}

	public any function $writeFlash(struct flash={}) {
		var loc = {};
		if (!StructKeyExists(arguments, "$locked")) {
			loc.lockName = "flashLock" & application.applicationName;
			loc.rv = $simpleLock(name=loc.lockName, type="exclusive", execute="$writeFlash", executeArgs=arguments);
		} else {
			if ($getFlashStorage() == "cookie") {
				cookie.flash = SerializeJSON(arguments.flash);
			} else {
				session.flash = arguments.flash;
			}
		}
		if (StructKeyExists(loc, "rv")) {
			return loc.rv;
		}
	}

	public void function $flashClear() {
		var loc = {};
		// only save the old flash if they want to keep anything
		if (StructKeyExists(request.wheels, "flashKeep")) {
			loc.flash = $readFlash();
		}

		// clear the current flash
		flashClear();

		// see if they wanted to keep anything
		if (StructKeyExists(loc, "flash")) {
			// delete any keys they don't want to keep
			if (Len(request.wheels.flashKeep)) {
				for (loc.key in loc.flash) {
					if (!ListFindNoCase(request.wheels.flashKeep, loc.key)) {
						StructDelete(loc.flash, loc.key);
					}
				}
			}
			// write to the flash
			$writeFlash(loc.flash);
		}
	}

	public void function $setFlashStorage(required string storage) {
		variables.$class.flashStorage = arguments.storage;
	}

	public string function $getFlashStorage() {
		var loc = {};
		loc.rv = variables.$class.flashStorage;
		return loc.rv;
	}
</cfscript>
