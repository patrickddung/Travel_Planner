<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>Travel_Palnner</title>
    <link rel="stylesheet" href="css/Style.css">
    <script src="jquery-3.6.1.min.js"></script>
</head>

<body>
    <link href="https://fonts.googleapis.com/css2?family=Do+Hyeon&family=Nanum+Myeongjo&family=Stylish&display=swap"
        rel="stylesheet">
    <div class="app-container">
        <div class="left-area">
            <div class="app-name"><a href="login.do" style="text-decoration:none;">메뉴</a></div>
            <br>
            <a href="worldmap.do" class="item-link active" id="pageLink">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" stroke="currentColor"
                    stroke-linecap="round" stroke-linejoin="round" stroke-width="2" class="feather feather-grid"
                    viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                        d="M3.055 11H5a2 2 0 012 2v1a2 2 0 002 2 2 2 0 012 2v2.945M8 3.935V5.5A2.5 2.5 0 0010.5 8h.5a2 2 0 012 2 2 2 0 104 0 2 2 0 012-2h1.064M15 20.488V18a2 2 0 012-2h3.064M21 12a9 9 0 11-18 0 9 9 0 0118 0z">
                    </path>
                </svg>
            </a>
            <a href="productList.do" class="item-link" id="pageLink">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" stroke="currentColor"
                    stroke-linecap="round" stroke-linejoin="round" stroke-width="2" class="feather feather-grid"
                    viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round"
                        d="M2.25 15.75l5.159-5.159a2.25 2.25 0 013.182 0l5.159 5.159m-1.5-1.5l1.409-1.409a2.25 2.25 0 013.182 0l2.909 2.909m-18 3.75h16.5a1.5 1.5 0 001.5-1.5V6a1.5 1.5 0 00-1.5-1.5H3.75A1.5 1.5 0 002.25 6v12a1.5 1.5 0 001.5 1.5zm10.5-11.25h.008v.008h-.008V8.25zm.375 0a.375.375 0 11-.75 0 .375.375 0 01.75 0z" />
                </svg>
            </a>
            <a href="worldList.do" class="item-link" id="pageLink">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" stroke="currentColor"
                    stroke-linecap="round" stroke-linejoin="round" stroke-width="2" class="feather feather-folder"
                    viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                        d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01">
                    </path>
                </svg>
            </a>
            <a href="Main_Content/Weather/Index_Weather.jsp" class="item-link" id="pageLink">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" stroke="currentColor"
                    stroke-linecap="round" stroke-linejoin="round" stroke-width="2" class="feather feather-folder"
                    viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round"
                        d="M2.25 15a4.5 4.5 0 004.5 4.5H18a3.75 3.75 0 001.332-7.257 3 3 0 00-3.758-3.848 5.25 5.25 0 00-10.233 2.33A4.502 4.502 0 002.25 15z" />
                </svg>
            </a>
            <a href="Main_Content/Airplane/Index_Airplane.jsp" class="item-link" id="pageLink">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" stroke="currentColor"
                    stroke-linecap="round" stroke-linejoin="round" stroke-width="2" class="feather feather-folder"
                    viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round"
                        d="M6 12L3.269 3.126A59.768 59.768 0 0121.485 12 59.77 59.77 0 013.27 20.876L5.999 12zm0 0h7.5" />
                </svg>
            </a>
            <a href="Main_Content/Puzzle/Index_Puzzle.jsp" class="item-link" id="pageLink">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" stroke="currentColor"
                    stroke-linecap="round" stroke-linejoin="round" stroke-width="2" class="feather feather-folder"
                    viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round"
                        d="M14.25 6.087c0-.355.186-.676.401-.959.221-.29.349-.634.349-1.003 0-1.036-1.007-1.875-2.25-1.875s-2.25.84-2.25 1.875c0 .369.128.713.349 1.003.215.283.401.604.401.959v0a.64.64 0 01-.657.643 48.39 48.39 0 01-4.163-.3c.186 1.613.293 3.25.315 4.907a.656.656 0 01-.658.663v0c-.355 0-.676-.186-.959-.401a1.647 1.647 0 00-1.003-.349c-1.036 0-1.875 1.007-1.875 2.25s.84 2.25 1.875 2.25c.369 0 .713-.128 1.003-.349.283-.215.604-.401.959-.401v0c.31 0 .555.26.532.57a48.039 48.039 0 01-.642 5.056c1.518.19 3.058.309 4.616.354a.64.64 0 00.657-.643v0c0-.355-.186-.676-.401-.959a1.647 1.647 0 01-.349-1.003c0-1.035 1.008-1.875 2.25-1.875 1.243 0 2.25.84 2.25 1.875 0 .369-.128.713-.349 1.003-.215.283-.4.604-.4.959v0c0 .333.277.599.61.58a48.1 48.1 0 005.427-.63 48.05 48.05 0 00.582-4.717.532.532 0 00-.533-.57v0c-.355 0-.676.186-.959.401-.29.221-.634.349-1.003.349-1.035 0-1.875-1.007-1.875-2.25s.84-2.25 1.875-2.25c.37 0 .713.128 1.003.349.283.215.604.401.96.401v0a.656.656 0 00.658-.663 48.422 48.422 0 00-.37-5.36c-1.886.342-3.81.574-5.766.689a.578.578 0 01-.61-.58v0z" />
                </svg>
            </a>
            <a href="chat.do" class="item-link" id="pageLink">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"
                    stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                    <path stroke-linecap="round" stroke-linejoin="round"
                        d="M20.25 8.511c.884.284 1.5 1.128 1.5 2.097v4.286c0 1.136-.847 2.1-1.98 2.193-.34.027-.68.052-1.02.072v3.091l-3-3c-1.354 0-2.694-.055-4.02-.163a2.115 2.115 0 01-.825-.242m9.345-8.334a2.126 2.126 0 00-.476-.095 48.64 48.64 0 00-8.048 0c-1.131.094-1.976 1.057-1.976 2.192v4.286c0 .837.46 1.58 1.155 1.951m9.345-8.334V6.637c0-1.621-1.152-3.026-2.76-3.235A48.455 48.455 0 0011.25 3c-2.115 0-4.198.137-6.24.402-1.608.209-2.76 1.614-2.76 3.235v6.226c0 1.621 1.152 3.026 2.76 3.235.577.075 1.157.14 1.74.194V21l4.155-4.155" />
                </svg>
            </a>
            <a href="worlduserList.do" class="item-link" id="pageLink">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"
                    stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                    <path stroke-linecap="round" stroke-linejoin="round"
                        d="M16.862 4.487l1.687-1.688a1.875 1.875 0 112.652 2.652L6.832 19.82a4.5 4.5 0 01-1.897 1.13l-2.685.8.8-2.685a4.5 4.5 0 011.13-1.897L16.863 4.487zm0 0L19.5 7.125" />
                </svg>
            </a>
            <a href="productuserList.do" class="item-link" id="pageLink">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" stroke="currentColor"
                    stroke-linecap="round" stroke-linejoin="round" stroke-width="2" class="feather feather-log-out"
                    viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round"
                        d="M12 10.5v6m3-3H9m4.06-7.19l-2.12-2.12a1.5 1.5 0 00-1.061-.44H4.5A2.25 2.25 0 002.25 6v12a2.25 2.25 0 002.25 2.25h15A2.25 2.25 0 0021.75 18V9a2.25 2.25 0 00-2.25-2.25h-5.379a1.5 1.5 0 01-1.06-.44z" />
                </svg>
            </a>
            <button class="btn-logout">
                <a href="logout.do" class="item-link" id="pageLink">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" stroke="currentColor"
                        stroke-linecap="round" stroke-linejoin="round" stroke-width="2" class="feather feather-log-out"
                        viewBox="0 0 24 24">
                        <path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4M16 17l5-5-5-5M21 12H9" />
                    </svg>
                </a>
            </button>
        </div>
        <div class="main-area">
            <section class="content-section">
                <h1 class="section-header">여행의 모든것</h1>
                <br>
                <div class="access-links">
                    <div class="access-link-wrapper">
                        <a href="worldmap.do">
                            <div class="access-icon">
                                <svg xmlns="http://www.w3.org/2000/svg" width="55" height="55" fill="none"
                                    viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6"
                                    color="black">
                                    <path stroke-linecap="round" stroke-linejoin="round"
                                        d="M12.75 3.03v.568c0 .334.148.65.405.864l1.068.89c.442.369.535 1.01.216 1.49l-.51.766a2.25 2.25 0 01-1.161.886l-.143.048a1.107 1.107 0 00-.57 1.664c.369.555.169 1.307-.427 1.605L9 13.125l.423 1.059a.956.956 0 01-1.652.928l-.679-.906a1.125 1.125 0 00-1.906.172L4.5 15.75l-.612.153M12.75 3.031a9 9 0 00-8.862 12.872M12.75 3.031a9 9 0 016.69 14.036m0 0l-.177-.529A2.25 2.25 0 0017.128 15H16.5l-.324-.324a1.453 1.453 0 00-2.328.377l-.036.073a1.586 1.586 0 01-.982.816l-.99.282c-.55.157-.894.702-.8 1.267l.073.438c.08.474.49.821.97.821.846 0 1.598.542 1.865 1.345l.215.643m5.276-3.67a9.012 9.012 0 01-5.276 3.67m0 0a9 9 0 01-10.275-4.835M15.75 9c0 .896-.393 1.7-1.016 2.25" />
                                </svg>
                            </div>
                        </a>
                        <span class="access-text">지도</span>
                    </div>
                    <div class="access-link-wrapper">
                        <a href="productList.do">
                            <div class="access-icon">
                                <svg xmlns="http://www.w3.org/2000/svg" width="55" height="55" fill="none"
                                    viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6"
                                    color="black">
                                    <path strokeLinecap="round" strokeLinejoin="round"
                                        d="M2.25 15.75l5.159-5.159a2.25 2.25 0 013.182 0l5.159 5.159m-1.5-1.5l1.409-1.409a2.25 2.25 0 013.182 0l2.909 2.909m-18 3.75h16.5a1.5 1.5 0 001.5-1.5V6a1.5 1.5 0 00-1.5-1.5H3.75A1.5 1.5 0 002.25 6v12a1.5 1.5 0 001.5 1.5zm10.5-11.25h.008v.008h-.008V8.25zm.375 0a.375.375 0 11-.75 0 .375.375 0 01.75 0z" />
                                </svg>
                            </div>
                        </a>
                        <span class="access-text">사진</span>
                    </div>
                    <div class="access-link-wrapper">
                        <a href="worldList.do" onclick="clean()">
                            <div class="access-icon">
                                <svg xmlns="http://www.w3.org/2000/svg" width="55" height="55" fill="none"
                                    viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6"
                                    color="black">
                                    <path stroke-linecap="round" stroke-linejoin="round"
                                        d="M16.862 4.487l1.687-1.688a1.875 1.875 0 112.652 2.652L10.582 16.07a4.5 4.5 0 01-1.897 1.13L6 18l.8-2.685a4.5 4.5 0 011.13-1.897l8.932-8.931zm0 0L19.5 7.125M18 14v4.75A2.25 2.25 0 0115.75 21H5.25A2.25 2.25 0 013 18.75V8.25A2.25 2.25 0 015.25 6H10" />
                                </svg>
                            </div>
                        </a>
                        <span class="access-text">계획</span>
                    </div>
                    <div class="access-link-wrapper">
                        <a href="Main_Content/Weather/Index_Weather.jsp">
                            <div class="access-icon">
                                <svg xmlns="http://www.w3.org/2000/svg" width="55" height="55" fill="none"
                                    viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6"
                                    color="black">
                                    <path stroke-linecap="round" stroke-linejoin="round"
                                        d="M2.25 15a4.5 4.5 0 004.5 4.5H18a3.75 3.75 0 001.332-7.257 3 3 0 00-3.758-3.848 5.25 5.25 0 00-10.233 2.33A4.502 4.502 0 002.25 15z" />
                                </svg>
                            </div>
                        </a>
                        <span class="access-text">날씨</span>
                    </div>
                </div>
            </section>
            <br>
            <br>
            <section class="content-section">
                <div class="section-header-wrapper">
                    <h1 class="section-header">다른 컨텐츠</h1>
                </div>
                <br>
                <div class="content-section-line">
                    <div class="section-part left">
                        <a class="image-wrapper" href="chat.do">
                            <div class="image-overlay">
                                <div class="video-info">
                                    <div class="video-info-text">
                                        <p class="video-name medium">만남의 광장</p>
                                    </div>
                                </div>
                            </div>
                            <img
                                src="https://th.bing.com/th/id/OIP.YNHKIZtfAynlcatnNRz6FAHaE8?w=250&h=187&c=7&r=0&o=5&pid=1.7" />
                        </a>
                    </div>
                    <div class="section-part right">
                        <div class="content-part-line">
                            <a href="worlduserList.do" class="image-wrapper">
                                <div class="image-overlay">
                                    <div class="video-info">
                                        <div class="video-info-text">
                                            <p class="video-name tiny">나의 일정</p>
                                        </div>
                                    </div>
                                </div>
                                <img
                                    src="https://images.unsplash.com/photo-1515552726023-7125c8d07fb3?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2167&q=80" />
                            </a>
                            <a href="productuserList.do" class="image-wrapper">
                                <div class="image-overlay">
                                    <div class="video-info">
                                        <div class="video-info-text">
                                            <p class="video-name tiny">나의 이미지</p>
                                        </div>
                                    </div>
                                </div>
                                <img
                                    src="https://images.unsplash.com/photo-1542359649-31e03cd4d909?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2167&q=80" />
                            </a>
                        </div>
                    </div>
                </div>
            </section>
            <footer>
                <br>
                <br>
                <Marquee behavior=left scrollamount=left>Welcome to Travel_Planner!! Enjoy your trip with
                    Travel_Planner!! Thankyou.</Marquee>
            </footer>
        </div>
        <div class="right-area">
            <div class="My_Profile">
                <%@ include file="Main_Content/MyProfile.jsp" %>
            </div>
        </div>
        <script>
            function clean() { // localStorage 초기화
                localStorage.clear();
            }
            var admin = "<%= (String) session.getAttribute("id") %>";
            if (admin == "관리자1") { // 만약 관리자라면 관리자 페이지로 이동할 수 있도록한다.
                location.href = "member/Master.jsp";
            }
            var success = "<%= (String) session.getAttribute("success") %>";
            console.log(success); // 일정 생성을 성공했는지 여부 반환

            if (document.referrer == "http://localhost:8080/Planner/joinmap.do") { // 일정생성 페이지에서 왔다면 생성여부 알려줌
                if (success != "null") {
                    alert(success);
                }
            }
        </script>
</body>

</html>