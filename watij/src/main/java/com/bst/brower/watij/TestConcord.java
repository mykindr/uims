package com.bst.brower.watij;

import junit.framework.TestCase;
import static watij.finders.SymbolFactory.name;
import watij.runtime.ie.IE;

public class TestConcord extends TestCase {
	public void testconcordfunction() throws Exception {
		IE ie = new IE();
		// �� IE �����
		ie.start();
		// ת�� concord77
		ie
				.goTo("http://concord77.cn.ibm.com/files/app?lang=en_US#/pinnedfiles");
		// �������
		ie.maximize();
		// ��ȫ��֤
		ie.link(name, "overridelink").click();
		// ��������������û���������
		ie.textField(name, "j_username").set("Abdul_000_006");
		ie.textField(name, "j_password").set("passw0rd");
		// �����½
		ie.button("��¼").click();
		// ������ͼ
		ie.screenCapture("D:\\Savelogin.png");
	}
}