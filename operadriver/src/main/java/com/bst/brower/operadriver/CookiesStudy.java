package com.bst.brower.operadriver;

import java.util.Set;

import org.openqa.selenium.Cookie;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.firefox.FirefoxDriver;

public class CookiesStudy {

	/**
	 * @author gongjf
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		System.setProperty("webdriver.firefox.bin",
				"D:\\Program Files\\Mozilla Firefox\\firefox.exe");
		WebDriver dr = new FirefoxDriver();
		dr.get("http://www.51.com");

		// ����һ��name = "name",value="value"��cookie
		Cookie cookie = new Cookie("name", "value");
		dr.manage().addCookie(cookie);

		// �õ���ǰҳ�������е�cookies������������ǵ�������name��value����Ч���ں�·��
		Set<Cookie> cookies = dr.manage().getCookies();
		System.out.println(String
				.format("Domain -> name -> value -> expiry -> path"));
		for (Cookie c : cookies)
			System.out.println(String.format("%s -> %s -> %s -> %s -> %s", c
					.getDomain(), c.getName(), c.getValue(), c.getExpiry(), c
					.getPath()));

		// ɾ��cookie�����ַ���

		// ��һ��ͨ��cookie��name
		dr.manage().deleteCookieNamed("CookieName");
		// �ڶ���ͨ��Cookie����
		dr.manage().deleteCookie(cookie);
		// ������ȫ��ɾ��
		dr.manage().deleteAllCookies();
	}
}