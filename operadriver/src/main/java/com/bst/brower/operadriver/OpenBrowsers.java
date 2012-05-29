package com.bst.brower.operadriver;

import java.io.File;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.firefox.FirefoxBinary;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.ie.InternetExplorerDriver;

public class OpenBrowsers {

	public static void main(String[] args) {
		// ��Ĭ��·����firefox
		WebDriver diver = new FirefoxDriver();

		// ��ָ��·����firefox,����1
		System.setProperty("webdriver.firefox.bin",
				"D:\\Program Files\\Mozilla Firefox\\firefox.exe");
		WebDriver dr = new FirefoxDriver();

		// ��ָ��·����firefox,����2
		File pathToFirefoxBinary = new File(
				"D:\\Program Files\\Mozilla Firefox\\firefox.exe");
		FirefoxBinary firefoxbin = new FirefoxBinary(pathToFirefoxBinary);
		WebDriver driver1 = new FirefoxDriver(firefoxbin, null);

		// ��ie
		WebDriver ie_driver = new InternetExplorerDriver();

		// ��chrome
		System.setProperty("webdriver.chrome.driver", "D:\\chromedriver.exe");
		System
				.setProperty(
						"webdriver.chrome.bin",
						"C:\\Documents and Settings\\gongjf\\Local Settings"
								+ "\\Application Data\\Google\\Chrome\\Application\\chrome.exe");

	}

}