package com.bst.brower.watij;
import static watij.finders.SymbolFactory.name;
import junit.framework.TestCase;
import watij.runtime.ie.IE;

public class TestWatijIBM extends TestCase {
	public void testgooglesearch() throws Exception {
		IE ie = new IE();
		// �� IE �����
		ie.start();
		// ת���ٶ���ҳ
		ie.goTo("www.baidu.com");
		// ������������롰IBM��
		ie.textField(name, "wd").set("IBM");
		// ������ٶ�һ�¡����в���
		ie.button("�ٶ�һ��").click();
		// �ȴ� 3 ��
		ie.wait(3);
	}
}