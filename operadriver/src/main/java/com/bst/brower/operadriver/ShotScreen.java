package com.bst.brower.operadriver;

import java.io.File;
import java.io.IOException;

import org.apache.commons.io.FileUtils;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.firefox.FirefoxDriver;

public class ShotScreen {

	/**
	 * @author gongjf
	 * @throws IOException
	 * @throws InterruptedException
	 */
	public static void main(String[] args) throws IOException,
			InterruptedException {

		System.setProperty("webdriver.firefox.bin",
				"D:\\Program Files\\Mozilla Firefox\\firefox.exe");
		WebDriver dr = new FirefoxDriver();
		dr.get("http://www.51.com");

		// ����ȴ�ҳ��������
		Thread.sleep(5000);
		// ��������ǵõ���ͼ��������D����
		File screenShotFile = ((TakesScreenshot) dr)
				.getScreenshotAs(OutputType.FILE);
		FileUtils.copyFile(screenShotFile, new File("D:/test.png"));
	}
}