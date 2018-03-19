<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
    hello,${name};
    <c:forEach items="${list}" var="ll">
        <c:out value="${ll}"/>
    </c:forEach>
</body>
</html>
