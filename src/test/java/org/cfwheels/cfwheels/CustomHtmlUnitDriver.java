package org.cfwheels.cfwheels;

import org.openqa.selenium.htmlunit.HtmlUnitDriver;

import com.gargoylesoftware.htmlunit.Page;
import com.gargoylesoftware.htmlunit.SgmlPage;

public class CustomHtmlUnitDriver extends HtmlUnitDriver {
	public String getPageSourceAsText() {
		Page page = lastPage();
		if (page == null) {
			return null;
		}

		if (page instanceof SgmlPage) {
			return ((SgmlPage) page).asText();
		}
		return getPageSource();
	}
}
