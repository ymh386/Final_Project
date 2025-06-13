    <%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <meta name="description" content="" />
    <meta name="author" content="" />
    <title>Dashboard - SB Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
    <link href="${pageContext.request.contextPath}/css/styles.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <style>/* Chart.js */
		@keyframes chartjs-render-animation{from{opacity:.99}to{opacity:1}}
		.chartjs-render-monitor{animation:chartjs-render-animation 1ms}
		.chartjs-size-monitor,.chartjs-size-monitor-expand,
		.chartjs-size-monitor-shrink{position:absolute;direction:ltr;left:0;top:0;right:0;bottom:0;overflow:hidden;pointer-events:none;visibility:hidden;z-index:-1}
		.chartjs-size-monitor-expand>div{position:absolute;width:1000000px;height:1000000px;left:0;top:0}
		.chartjs-size-monitor-shrink>div{position:absolute;width:200%;height:200%;left:0;top:0}
    .main-content {
      padding-top: 2rem;    /* 탑바와 거리감 */
      padding-left: 2rem;   /* 사이드바와 거리감 */
    }
	</style>