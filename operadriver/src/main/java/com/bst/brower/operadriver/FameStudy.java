package com.bst.brower.operadriver;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.firefox.FirefoxDriver;

public class FameStudy {

	public static void main(String[] args) {
		WebDriver dr = new FirefoxDriver();
		String url = "\\Your\\Path\\to\\main.html";
		dr.get(url);

		// ��default content��λid="id1"��div
		dr.findElement(By.id("id1"));

		// ��ʱ��û�н��뵽id="frame"��frame��ʱ����������ᱨ��
		dr.findElement(By.id("div1"));// ����
		dr.findElement(By.id("input1"));// ����

		// ����id="frame"��frame�У���λid="div1"��div��id="input1"�������
		dr.switchTo().frame("frame");
		dr.findElement(By.id("div1"));
		dr.findElement(By.id("input1"));

		// ��ʱ��û������frame�������λdefault content�е�Ԫ��Ҳ�ᱨ��
		dr.findElement(By.id("id1"));// ����

		// ����frame,����default content;���¶�λid="id1"��div
		dr.switchTo().defaultContent();
		dr.findElement(By.id("id1"));
	}

}