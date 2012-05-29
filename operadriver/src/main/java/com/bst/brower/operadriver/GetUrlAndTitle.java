package com.bst.brower.operadriver;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.firefox.FirefoxDriver;

public class GetUrlAndTitle {
	public static void main(String[] args) {
		String url = "http://www.51.com";
		WebDriver driver = new FirefoxDriver();

		driver.get(url);

		// �õ�title
		String title = driver.getTitle();

		// �õ���ǰҳ��url
		String currentUrl = driver.getCurrentUrl();

		// ���title��currenturl
		System.out.println(title + "\n" + currentUrl);

	}
}