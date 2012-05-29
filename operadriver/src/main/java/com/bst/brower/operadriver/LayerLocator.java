package com.bst.brower.operadriver;

import java.util.List;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.firefox.FirefoxDriver;

public class LayerLocator {

	/**
	 * @author gongjf
	 */
	public static void main(String[] args) {

		WebDriver driver = new FirefoxDriver();
		driver.get("http://www.51.com");

		// ��λclassΪ"login"��div��Ȼ����ȡ�������������label������ӡ�����ǵ�ֵ
		WebElement element = driver.findElement(By.className("login"));
		List<WebElement> el = element.findElements(By.tagName("label"));
		for (WebElement e : el)
			System.out.println(e.getText());

	}

}