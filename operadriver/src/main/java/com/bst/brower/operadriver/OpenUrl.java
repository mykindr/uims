package com.bst.brower.operadriver;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.firefox.FirefoxDriver;

public class OpenUrl {
	public static void main(String[] args) {
		String url = "http://www.51.com";
		WebDriver driver = new FirefoxDriver();

		// ��get����
		driver.get(url);

		// ��navigate������Ȼ���ٵ���to����
		driver.navigate().to(url);
	}
}