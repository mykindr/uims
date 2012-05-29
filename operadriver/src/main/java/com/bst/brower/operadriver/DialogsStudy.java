package com.bst.brower.operadriver;

import org.openqa.selenium.Alert;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.firefox.FirefoxDriver;

public class DialogsStudy {

	/**
	 * @author gongjf
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		System.setProperty("webdriver.firefox.bin",
				"D:\\Program Files\\Mozilla Firefox\\firefox.exe");
		WebDriver dr = new FirefoxDriver();
		String url = "file:///C:/Documents and Settings/gongjf/����/selenium_test/Dialogs.html";// "/Your/Path/to/main.html"
		dr.get(url);

		// �����һ����ť������Ի�����������֣�Ȼ����
		dr.findElement(By.id("alert")).click();
		Alert alert = dr.switchTo().alert();
		String text = alert.getText();
		System.out.println(text);
		alert.dismiss();

		// ����ڶ�����ť������Ի�����������֣�Ȼ����ȷ��
		dr.findElement(By.id("confirm")).click();
		Alert confirm = dr.switchTo().alert();
		String text1 = confirm.getText();
		System.out.println(text1);
		confirm.accept();

		// �����������ť������������֣�Ȼ����ȷ�ϣ����
		dr.findElement(By.id("prompt")).click();
		Alert prompt = dr.switchTo().alert();
		String text2 = prompt.getText();
		System.out.println(text2);
		prompt.sendKeys("jarvi");
		prompt.accept();

	}

}