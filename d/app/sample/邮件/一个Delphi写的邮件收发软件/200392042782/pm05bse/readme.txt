{------------------------P-Mail 0.5 beta��-----------------
��̹��ߣ�Delphi 6 + D6_upd2 
������������ɫ PLQ������
�����������봿����ѣ�����ѧϰʹ�ã�ϣ������ʹ����ʱ������λ�
������Ա��������˸Ľ���Ҳϣ������������ϵ
My E-Mail:plq163001@163.com
	  plq163003@163.com
-----------------------------------------------------2002.5.19}


  �����ҳ�����Ʊ�������Ʒ�����ڵ�ʱ�ӵ�֪ͨ��ʱ�����ֻʣһ����
��ʱ�䣬��������VC++����һ�����ο����ͷʹ�����ת����Delphi����ԭ
������ѧC++�ģ�����Ӳ��ͷƤ��ǰ����������ʵѧ��һ�����Ժ�ת����һ��
�����Ǻ����׵ģ���Ҳ���ҵĵ�һ��WindowsӦ�ó����ڲ����ϵĵ�ʱ����
�󲿷ֵ�Demo���ǵ��ʻ���û�ж��ʻ�������û�е�ַ�����ܣ��������Լ���
�տ�ʼ��ʱ�����ܼ򵥣����ö�ini�ļ��Ķ�д��ʵ�ֶ��ʻ��ģ���������ʦ
�Ĺ����£�ת�����ݿ⴦���������ݿ�����Ҳ�ǵ�һ�νӴ����տ�ʼ�о���
�ѣ�����csdn��λ��Ϻ�İ����£���ս��������һ���٣����ڳ��߳��ͣ���ȻҲ
���˵�һ������Ȼ����������кܶ����⣬��Ҳ����Ϊʲô�������ԭ��������
ԭ��Ҳ����Ϊ��ˣ��ҲŹ���ԭ���룬ϣ����λͬ�ø���ָ�㣡

˵�����Ҽ��ṩԭ���룬Ҳ�ṩ�ؼ������б���õĳ�����һ�ݿ����ĵ�˵������
�������������һ���ĳ��룬����ע�⣡

����������ĵ������ؼ�
Mail2000
XPMenu
CoolTrayIcon
Delphi6�Դ���Idϵ�пؼ�



-----------�������һ������bug,����ע�⣡����------------------

����ϣ����λ������

{��ַ���������ֶο�����������e-mail��ַ�����أ�
���޸ĵ�ַʱ��������ʾ���Ǹü�¼����Ӧ�ֶΣ�Ȼ������������
���в�����
1��������e-mail��ַ���䣬����ԭ����
2�������䣬�ҿ��������������һ����e-mail��ַ���䣻
3���������䣬e-mail��ַ�䣬���������������e-mail��ַ
����Ȼ�������¼��ԭ�е��Ǹ�e-mail��ַ�����ظ���
4.�����䣬�ҿ��������������һ����e-mail��ַҲ�䣬������
���������e-mail��ַ����Ȼ�������¼��ԭ�е��Ǹ�e-mail��ַ��
���ظ���
�������£�
procedure TfmAsSet.btnSetClick(Sender: TObject);
begin
       with fmAsN.adoqAsN do
       begin
                close;
                sql.Clear;
                sql.Add('select * from AddressNote where FromAddress=:FromAddress');	//�����Ƿ��е�ַ�ظ�
                Parameters.ParamByName('FromAddress').Value:=edtFromAddress.Text;
                open;
       end;

       if fmAsN.adoqAsN.RecordCount=1 then	//��¼��������1�����������
       begin
                if  edtFromAddress.Text<>fmAsN.lvAddress.Selected.SubItems.Text then	//��������ԭ�е�ַ����ͬ����϶��ǵ�ַ�ظ���
                begin
                        showmessage('��ַ������');
                        fmAsN.adoqAsN.Close;
                        exit;
                end



                else			//�����ͬ����˵���ǵ�ַ������������
                begin
                     with fmAsN.adoqAsN do
                     begin
                                close;
                                sql.Clear;
                                SQL.Text:='select * from AddressNote where FromAddress='''+trim(fmAsN.lvAddress.Selected.SubItems.Text)+'''';
                                Open; 
                                Edit;
                                FieldByName('FromName').AsString:=edtFromName.Text;
                                FieldByName('FromAddress').AsString:=edtFromAddress.Text;
                                Post;
                                Close;
                     end;

                     {fmAsN.lvAddress.Selected.Caption:=edtFromName.Text;
                     fmAsN.lvAddress.Selected.SubItems.Text:=edtFromAddress.Text;
                     fmAsN.lvAddress.Update;}
                     fmAsN.lvAddress.Clear;
                     fmAsN.UpdatelvAddress(Sender);

                     fmAsN.labFromName.Caption:=fmAsN.lvAddress.Selected.Caption;
                     fmAsN.labFormAddress.Caption:=fmAsN.lvAddress.Selected.SubItems.Strings[0];
                     fmAsSet.Close;

                end;

       end;
       with fmAsN.adoqAsN do
       begin
                close;
                sql.Clear;
                SQL.Text:='select * from AddressNote where FromAddress='''+fmAsN.lvAddress.Selected.SubItems.Text+'''';
                Open; 
                Edit;
                FieldByName('FromName').AsString:=edtFromName.Text;
                FieldByName('FromAddress').AsString:=edtFromAddress.Text;
                Post;
                Close;
        end;

        {fmAsN.lvAddress.Selected.Caption:=edtFromName.Text;
        fmAsN.lvAddress.Selected.SubItems.Text:=edtFromAddress.Text;
        fmAsN.lvAddress.Update;}

        fmAsN.lvAddress.Clear;
        fmAsN.UpdatelvAddress(Sender);		//ʵ�����Ǵӵ�ַ���������¶�������

        fmAsN.labFromName.Caption:=fmAsN.lvAddress.Selected.Caption;
        fmAsN.labFormAddress.Caption:=fmAsN.lvAddress.Selected.SubItems.Strings[0];
        fmAsSet.Close;

end;

���ڵ������������ģ��ҹ��⽫e-mail��ַ�޸ĵ������ԭ��e-mail��ַ��ͬʱ�� ����������
������ʾ�������� ��Ȼ���ҹر��޸ĵ�ַ���ڣ��ٴ�ѡ��ղ��Ǹ���¼�����޸ĵ�ַ����
�ֹ��⽫e-mail��ַ�޸ĵ������ԭ��e-mail��ַ��ͬʱ������Ȼû��ʾ����ODBC���ֶ�
�����ظ��ľ���Ҳû�У������Ѿ���e-mail��ַ�ֶ���Ϊ�������Ҳ����ظ��˰�����ʼ����Ϊ
ֻ����lvAddress�г�����ͬ��¼�������Ҵ򿪱�ʱ����Ҳ��������ͬ�ļ�¼��������ǣ�����
�����Ĳ����Ժ󣬶Ա�Ĳ���ȫ���ˣ�����¼�¼ʱ����ַ�������ظ���ɾ����¼ɾ���ˣ�����
�ֶ��򿪱������м�¼ȫ��ɾ��������Żָ�������}