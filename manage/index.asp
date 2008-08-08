﻿<!--#include file="conn.asp"-->
<!--#include file="const.asp"-->
<!--#include file="md5.asp"-->
<%
if Request.QueryString("username")<>"" then
	checkuser()
else
	header()
	Select Case Request.QueryString("action")
		Case "login"
			login()
		Case "reg"
			reg()
		Case "save_reg"
			save_reg()
		Case "logout"
			logout()
		Case Else
			main()
	End Select
	footer()
end if



sub main()
	menu()
	dim rndnum,verifycode,num1
	Randomize
	Do While Len(rndnum)<4
	num1=CStr(Chr((57-48)*rnd+48))
	rndnum=rndnum&num1
	loop
	session("verifycode")=rndnum
%>
<table border="0" cellpadding="2" cellspacing="1" class="tableborder" width="98%">
  <form action="index.asp?action=login" method="post" onsubmit="return check(this);">
    <tr>
      <th colspan="2" align="left">用户登录:</th>
    </tr>
    <tr>
      <td align="right">用户名：</td>
      <td><input name="username" type="text" id="username" size="25" tabindex="1" />
        还没有CMP？<a href="index.asp?action=reg" tabindex="5"><span style="font-weight: bold">免费注册新用户</span></a></td>
    </tr>
    <tr>
      <td align="right">密　码：</td>
      <td><input name="password" type="password" id="password" size="25" tabindex="2" />
        忘记密码？联系管理员(邮箱:<a href="mailto:<%=site_email%>" target="_blank"><%=site_email%></a> 或QQ:<a href="<%=getQqUrl(site_qq)%>" target="_blank"><%=site_qq%></a>)</td>
    </tr>
    <tr>
      <td align="right">验证码：</td>
      <td><input name="verifycode" type="text" id="verifycode" size="6" maxlength="4" tabindex="3" />
        <span class="verifycode" onselectstart="return false;" style="-moz-user-select:none; cursor:default;"><%=getCode(session("verifycode"))%></span></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td><input name="submit" type="submit" value="登录" style="width:50px;" tabindex="4" /></td>
    </tr>
  </form>
</table>
<script type="text/javascript">
function check(o){
	if(o.username.value==""){
		alert("用户名不能为空！");
		o.username.focus();
		return false;
	}
	if(o.password.value==""){
		alert("用户密码不能为空！");
		o.password.focus();
		return false;
	}
	if(o.verifycode.value==""){
		alert("验证码不能为空！");
		o.verifycode.focus();
		return false;
	}
	return true;
}
</script>
<table border="0" cellpadding="2" cellspacing="1" class="tableborder" width="98%">
  <tr>
    <th align="left">系统公告:</th>
  </tr>
  <tr>
    <td><%=UnCheckStr(site_ads)%></td>
  </tr>
</table>
<%
end sub

sub reg()
	menu()
if user_reg="1" then
%>
<table border="0" cellpadding="2" cellspacing="1" class="tableborder" width="98%">
  <form action="index.asp?action=save_reg" method="post" onsubmit="return check(this);">
    <tr>
      <th colspan="2" align="left">用户注册:</th>
    </tr>
    <tr>
      <td align="right">用户名：</td>
      <td><input name="username" type="text" id="username" size="30" maxlength="200" onchange="check_username(this)" />
        <span id="reg_username" style="color:#FF0000;"></span></td>
    </tr>
    <tr>
      <td align="right">密码：</td>
      <td><input name="password" type="password" id="password" size="30" /></td>
    </tr>
    <tr>
      <td align="right">确认密码：</td>
      <td><input name="passwordcheck" type="password" id="passwordcheck" size="30" /></td>
    </tr>
    <tr>
      <td align="right">邮箱：</td>
      <td><input name="email" type="text" id="email" size="30" maxlength="50" /></td>
    </tr>
    <tr>
      <td align="right">QQ：</td>
      <td><input name="qq" type="text" id="qq" size="30" maxlength="50" /></td>
    </tr>
    <tr>
      <td align="right">播放器名称：</td>
      <td><input name="cmp_name" type="text" id="cmp_name" size="50" maxlength="200" /></td>
    </tr>
    <tr>
      <td align="right">网址：</td>
      <td><input name="cmp_url" type="text" id="cmp_url" size="50" maxlength="200" /></td>
    </tr>
    <%if user_check="1" then%>
    <tr>
      <td align="right">注：</td>
      <td>系统开启了新注册用户需要审核，请如实填写您的注册信息</td>
    </tr>
    <%end if%>
    <tr>
      <td>&nbsp;</td>
      <td><input name="submit" type="submit" value="提交" style="width:50px;" /></td>
    </tr>
  </form>
</table>
<script type="text/javascript">
var username_err = "";
var ru = document.getElementById("reg_username");
function check_username(o){
	username_err = "";
	var un = o.value;
	if(un.length < 3){
		username_err = "用户名的长度不能小于3";
		ru.innerHTML = username_err;
		return;
	}
	//检测是否已经存在
	ajaxSend("GET","index.asp?rd="+Math.round()+"&username="+un,true,null,completeHd,errorHd)
}
function completeHd(data){
	//alert(data);
	if(data != ""){
		username_err = data;
		ru.innerHTML = username_err;
	} else {
		ru.innerHTML = "";
	}
}
function errorHd(errmsg){
	alert(errmsg);
}
function check(o){
	if(o.username.value==""){
		alert("用户名不能为空！");
		o.username.focus();
		return false;
	}
	if (username_err!=""){
		alert(username_err);
		o.username.select();
		return false;
	}
	if(o.password.value==""){
		alert("用户密码不能为空！");
		o.password.focus();
		return false;
	}
	if(o.passwordcheck.value==""){
		alert("确认密码不能为空！");
		o.passwordcheck.focus();
		return false;
	}
	if(o.password.value!=o.passwordcheck.value){
		alert("确认密码和密码不一致，请重新输入！");
		o.password.focus();
		o.password.value = "";
		o.passwordcheck.value = "";
		return false;
	}
	if(o.cmp_name.value==""){
		alert("播放器名称不能为空！");
		o.cmp_name.focus();
		return false;
	}
	return true;
}
</script>
<%
else
%>
<table border="0" cellpadding="2" cellspacing="1" class="tableborder" width="98%">
  <tr>
    <th align="left">用户注册:</th>
  </tr>
  <tr>
    <td align="center">站点暂时关闭用户注册。如有任何问题，请查看<a href="index.asp">系统公告</a>或联系管理员：<br />
      邮箱：<a href="mailto:<%=site_email%>" title="<%=site_email%>" target="_blank"><%=site_email%></a><br />
      QQ：<a href="<%=getQqUrl(site_qq)%>" target="_blank"><%=site_qq%></a></td>
  </tr>
</table>
<%
end if
end sub

sub checkuser()
	set rs=conn.Execute("select username from cmp_user where username='"&Checkstr(Request.QueryString("username"))&"'")
	if not rs.eof then
    	response.Write("用户名已经存在")
	end if
	rs.close
	set rs=nothing
end sub

sub save_reg()
	dim UserName,PassWord,email,qq,cmp_name,cmp_url
	dim userstatus
	if user_check="1" then
		userstatus = "0"
	else
		userstatus = "1"
	end if
	UserName=Checkstr(Request.Form("username"))
	PassWord=md5(request.Form("password")+UserName,16)
	email=Checkstr(Request.Form("email"))
	qq=Checkstr(Request.Form("qq"))
	cmp_name=Checkstr(Request.Form("cmp_name"))
	cmp_url=Checkstr(Request.Form("cmp_url"))
	sql = "select username from cmp_user where username='"&UserName&"'"
	set rs=conn.Execute(sql)
		if rs.eof then
			'id,username,password,userstatus,regtime,lasttime,lastip,email,qq,logins,cmp_name,cmp_url,config,list
			sql = "insert into cmp_user "
			sql = sql & "(username,[password],userstatus,regtime,lasttime,lastip,email,qq,cmp_name,cmp_url) values("
			sql = sql & "'"&UserName&"','"&PassWord&"',"&userstatus&","&SqlNowString&","&SqlNowString&",'"&UserTrueIP&"','"&email&"','"&qq&"','"&cmp_name&"','"&cmp_url&"')"
			conn.execute(sql)
			SucMsg = "您的注册信息已经提交成功。"
			if user_check="1" then
				SucMsg = SucMsg & "请等待管理员的审核！"
			end if
			cenfun_suc("index.asp")
		else
			ErrMsg = "用户名已经存在<br />"
			cenfun_error()
		end if
	rs.close
	set rs=nothing
end sub

sub goback(msg)
%>
<script type="text/javascript">
alert("<%=msg%>");
window.location = "index.asp";
</script>
<%
end sub

sub login()
	Dim UserName,PassWord,verifycode
	UserName=Checkstr(Request.Form("username"))
	PassWord=md5(request.Form("password")+UserName,16)
	verifycode=Checkstr(Request.Form("verifycode"))
	If verifycode="" or verifycode<>session("verifycode") Then
		session("verifycode")=""
		goback("验证码输入有误！请重新输入正确的信息。")
    	response.End
		Exit Sub
	Elseif 	session("verifycode")="" then
		goback("请不要重复提交，如需重新登陆请返回登陆页面。")
    	response.End
		Exit Sub
	End If
	Session("verifycode")=""
	sql = "select userstatus from cmp_user where username='"&UserName&"' and password='"&PassWord&"'"
	set rs=conn.Execute(sql)
	if rs.eof and rs.bof then
		rs.close
		set rs=nothing
		goback("您输入的用户名和密码不正确。")
    	response.End
		Exit Sub
	else
		'用户状态 0未激活，1锁定，2删除，5正常，9管理员
		if rs("userstatus") = 0 then
			ErrMsg = "您的帐号还没有激活，请耐心等待管理员的审核或及时联系管理员。"
			cenfun_error()
		elseif rs("userstatus") = 1 then
			ErrMsg = "对不起！您的帐号被管理员【锁定】，有任何问题请联系管理员。"
			cenfun_error()
		else
			'session超时时间
			Session.Timeout = 45
			Session(CookieName & "_username") = UserName
			if rs("userstatus") = 9 then
				Session(CookieName & "_admin") = UserName
			else
				Session(CookieName & "_admin") = ""
			end if
			sql = "Update cmp_user Set Lasttime="&SqlNowString&",Lastip='"&UserTrueIP&"',logins=logins+1 Where username='"&UserName&"'"
			'response.Write(sql)
			conn.Execute(sql)
			rs.close
			set rs=nothing
			Response.Redirect "manage.asp"
		end if
	end if	
end sub

sub logout()
	Session(CookieName & "_username")=""
	Session(CookieName & "_admin")=""
	Response.Redirect("index.asp")
end sub
%>
