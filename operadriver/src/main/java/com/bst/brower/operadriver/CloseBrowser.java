package com.bst.brower.operadriver;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.firefox.FirefoxDriver;

public class CloseBrowser {
	public static void main(String[] args) {
		String url = "http://www.51.com";
		WebDriver driver = new FirefoxDriver();

		driver.get(url);

		// ��quit����
		driver.quit();

		// ��close����
		driver.close();
	}
}