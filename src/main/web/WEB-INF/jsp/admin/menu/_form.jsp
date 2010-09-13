<%@ page contentType="text/html; charset=UTF8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/xml" prefix="x" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<form:form modelAttribute="menuItem" method="post" action="${action}" class="cssform">
	<form:hidden path="id" />
	<c:if test="${menuItem.fkMenuTree != null}">
		<form:hidden path="fkMenuTree.id" />
	</c:if>
	<c:if test="${menuItem.fkParent != null}">
		<form:hidden path="fkParent.id" />
	</c:if>
	<c:if test="${conf != null}">
		<form:hidden path="fkGadgetInstance.id" />
		<form:hidden path="fkGadgetInstance.type" />
	</c:if>
	<form:hidden path="menuOrder" />
	<c:if test="${conf != null }">
	<fieldset>
		<legend>タイプ</legend>
		<p>
			<c:if test="${conf != null}">
			<x:choose>
				<x:when select="$conf/widgetConfiguration/@title"><x:out select="$conf/widgetConfiguration/@title" /></x:when>
				<x:when select="$conf/Module/ModulePrefs/@directory_title"><x:out select="$conf/Module/ModulePrefs/@directory_title" /></x:when>
				<x:when select="$conf/Module/ModulePrefs/@title"><x:out select="$conf/Module/ModulePrefs/@title" /></x:when>
				<x:otherwise>${menuItem.type}</x:otherwise>
			</x:choose>
			</c:if>
		</p>
	</fieldset>
	</c:if>
	<fieldset>
		<legend>共通設定</legend>
		<p>
			<form:label for="title" path="title" cssErrorClass="error">タイトル</form:label>
			<form:input path="title" /><form:errors path="title" />
		</p>
		<p>
			<form:label for="href" path="href" cssErrorClass="error">リンク</form:label>
			<form:input path="href" /><form:errors path="href" />
		</p>
		<p>
			<label>公開設定</label>
			<span class="radio">
				<form:radiobutton path="publish" value="0" label="非公開" cssErrorClass="error" />
				<form:radiobutton path="publish" value="1" label="公開" cssErrorClass="error" />
				<form:errors path="publish" />
			</span>
		</p>
		<p>
			<form:label for="alert" path="alert" cssErrorClass="error">通知方法</form:label>
			<form:select path="alert">
				<form:option value="0" label="通知しない"/>
				<form:option value="1" label="通知する" selected="true"/>
				<form:option value="2" label="強制的に追加する"/>
			</form:select>
			<form:errors path="alert" />
		</p>
	</fieldset>
	<c:if test="${conf != null}">
	<fieldset id="gadget_settings">
		<legend>ガジェット設定</legend>
		<c:if test="${conf != null}">
		<x:forEach var="userPref" select="$conf//UserPref">
			<x:if select="$userPref/@admin_datatype or not($userPref/@datatype) or $userPref/@datatype!='hidden'">
				<x:choose>
					<x:when select="$userPref/@admin_datatype">
						<c:set var="datatype"><x:out select="$userPref/@admin_datatype"/></c:set>
					</x:when>
					<x:otherwise>
						<c:set var="datatype"><x:out select="$userPref/@datatype"/></c:set>
					</x:otherwise>
				</x:choose>
				<p class="${datatype}">
					<label><x:out select="$userPref/@display_name"/></label>
					<c:set var="name"><x:out select="$userPref/@name"/></c:set>
					<x:choose>
						<x:when select="$userPref/EnumValue">
							<select name="fkGadgetInstance.userPrefs[${name}]" class="${datatype}">
							<x:forEach var="enum" select="$userPref/EnumValue">
								<c:set var="value"><x:out select="$enum/@value"/></c:set>
								<c:set var="display_value"><x:out select="$enum/@display_value"/></c:set>
								<c:choose>
									<c:when test="${menuItem.fkGadgetInstance.userPrefs[name] == value}">
										<option value="${value}" selected="selected">${display_value}</option>
									</c:when>
									<c:otherwise>
										<option value="${value}">${display_value}</option>
									</c:otherwise>
								</c:choose>
							</x:forEach>
							</select>
						</x:when>
						<x:otherwise>
							<input type="${datatype}" name="fkGadgetInstance.userPrefs[${name}]" value="${menuItem.fkGadgetInstance.userPrefs[name]}" class="${datatype}"/>
						</x:otherwise>
					</x:choose>
				</p>
			</x:if>
		</x:forEach>
		</c:if>
	</fieldset>
	</c:if>
	<p>
		<input type="submit" value="作成" class="button"/>
		<input type="reset" value="リセット" class="button" />
	</p>
</form:form>
<script type="text/javascript">
<c:if test="${menuItem.fkGadgetInstance != null}">
rebuildGadgetUserPrefs();
</c:if>
$("#menuItem").ajaxForm(function(html){
	$("#menu_right").html(html);
});
$("#menuItem input.button").button();
</script>