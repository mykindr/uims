package com.bst.brower.operadriver;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.support.ui.Select;

public class SelectsStudy {

	/**
	 * @author gongjf
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		System.setProperty("webdriver.firefox.bin",
				"D:\\Program Files\\Mozilla Firefox\\firefox.exe");
		WebDriver dr = new FirefoxDriver();
		dr.get("http://passport.51.com/reg2.5p");

		// ͨ�������б���ѡ�������ѡ�еڶ����2011��
		Select selectAge = new Select(dr.findElement(By.id("User_Age")));
		selectAge.selectByIndex(2);

		// ͨ�������б��е�ѡ���value����ѡ��"�Ϻ�"��һ��
		Select selectShen = new Select(dr.findElement(By.id("User_Shen")));
		selectShen.selectByValue("�Ϻ�");

		// ͨ�������б���ѡ��Ŀɼ��ı�ѡ ��"�ֶ�"��һ��
		Select selectTown = new Select(dr.findElement(By.id("User_Town")));
		selectTown.selectByVisibleText("�ֶ�");

		// ����ֻ�������һ�������б�����ѡ���click����ѡ��ѡ��
		Select selectCity = new Select(dr.findElement(By.id("User_City")));
		for (WebElement e : selectCity.getOptions())
			e.click();
	}

}