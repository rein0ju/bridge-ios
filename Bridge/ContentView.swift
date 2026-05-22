//

//  ContentView.swift

//  Bridge

//

//  Created by rein_seo on 5/13/26.

//

import SwiftUI

struct BridgeTheme {

    static let blue = Color(red: 0.10, green: 0.37, blue: 0.95)

    static let background = Color(red: 0.96, green: 0.97, blue: 0.99)

    static let ink = Color(red: 0.07, green: 0.10, blue: 0.17)

    static let muted = Color(red: 0.43, green: 0.50, blue: 0.61)

}

struct Course: Identifiable, Equatable {

    let id: UUID

    var code: String

    var name: String

    var day: String

    var startHour: Int

    var endHour: Int

    var building: String

    var room: String

    var professor: String

    var color: Color

    init(id: UUID = UUID(), code: String, name: String, day: String, startHour: Int, endHour: Int, building: String, room: String, professor: String, color: Color) {

        self.id = id

        self.code = code

        self.name = name

        self.day = day

        self.startHour = startHour

        self.endHour = endHour

        self.building = building

        self.room = room

        self.professor = professor

        self.color = color

    }

    var timeText: String {

        "\(displayHour(startHour)) - \(displayHour(endHour))"

    }

    private func displayHour(_ hour: Int) -> String {

        let suffix = hour >= 12 ? "PM" : "AM"

        let display = hour == 0 ? 12 : hour > 12 ? hour - 12 : hour

        return "\(display) \(suffix)"

    }

}

struct BoardPost: Identifiable {

    let id = UUID()

    let category: String

    let title: String

    let detail: String

    let comments: Int

}

struct ContentView: View {

    @State private var authStep = -1
    @State private var onboardingStartPage = 0

    @State private var selectedTab = 0

    @State private var selectedSemester = "Fall 2026"

    @State private var showingAddCourse = false

    @State private var courseToEdit: Course?

    @State private var showingWritePost = false

    @State private var courses: [Course] = [

        Course(code: "LIS 201", name: "The Information Society", day: "Mon", startHour: 10, endHour: 11, building: "HC White", room: "6191", professor: "Prof. Miller", color: Color(red: 0.80, green: 0.89, blue: 1.0)),

        Course(code: "LIS 201", name: "The Information Society", day: "Wed", startHour: 10, endHour: 11, building: "HC White", room: "6191", professor: "Prof. Miller", color: Color(red: 0.80, green: 0.89, blue: 1.0)),

        Course(code: "CS 300", name: "Programming II", day: "Mon", startHour: 12, endHour: 13, building: "CS Building", room: "1240", professor: "Prof. Lee", color: Color(red: 0.88, green: 0.85, blue: 1.0)),

        Course(code: "CS 300", name: "Programming II", day: "Wed", startHour: 12, endHour: 13, building: "CS Building", room: "1240", professor: "Prof. Lee", color: Color(red: 0.88, green: 0.85, blue: 1.0)),

        Course(code: "STAT 240", name: "Data Science Modeling", day: "Tue", startHour: 13, endHour: 15, building: "Van Vleck", room: "B102", professor: "Prof. Brown", color: Color(red: 0.82, green: 0.95, blue: 0.86)),

        Course(code: "STAT 240", name: "Data Science Modeling", day: "Thu", startHour: 13, endHour: 15, building: "Van Vleck", room: "B102", professor: "Prof. Brown", color: Color(red: 0.82, green: 0.95, blue: 0.86)),

        Course(code: "GEOG 170", name: "Our Digital Globe", day: "Wed", startHour: 9, endHour: 10, building: "Science Hall", room: "180", professor: "Prof. Davis", color: Color(red: 1.0, green: 0.92, blue: 0.65)),

        Course(code: "GEOG 170", name: "Our Digital Globe", day: "Fri", startHour: 9, endHour: 10, building: "Science Hall", room: "180", professor: "Prof. Davis", color: Color(red: 1.0, green: 0.92, blue: 0.65))

    ]

    private let posts: [BoardPost] = [

        BoardPost(category: "정보", title: "CPT 신청 타임라인 정리해봤어요", detail: "ISS 서류 준비부터 승인까지 어떤 순서로 진행되는지 한 번에 정리했어요.", comments: 21),

        BoardPost(category: "룸메이트", title: "8월 입주 룸메이트 구하는 사람 있나요?", detail: "캠퍼스 근처 2B2B 생각 중이고 조용한 생활 패턴이면 좋겠어요.", comments: 12),

        BoardPost(category: "자유", title: "매디슨 여름에 남는 사람들 뭐 하고 지내요?", detail: "여름 수업 안 듣는데 운동, 알바, 프로젝트 같이 할 사람 있으면 좋겠어요.", comments: 15),

        BoardPost(category: "인턴십", title: "F-1 학생도 온캠퍼스 잡 지원 가능한가요?", detail: "학교 안 포지션인데 주당 시간 제한이랑 SSN 신청 가능 여부가 궁금해요.", comments: 9)

    ]

    private let semesters = ["Fall 2026", "Spring 2026", "Fall 2025", "Spring 2025"]

    private let days = ["Mon", "Tue", "Wed", "Thu", "Fri"]

    private let dayLabels = ["Mon": "월", "Tue": "화", "Wed": "수", "Thu": "목", "Fri": "금"]

    private let hours = Array(9...15)

    private var uniqueCourses: [Course] {

        var seen: Set<String> = []

        return courses.filter { course in

            if seen.contains(course.code) { return false }

            seen.insert(course.code)

            return true

        }

    }

    private var nextCourse: Course? {

        courses.filter { $0.day == "Mon" }.sorted { $0.startHour < $1.startHour }.first

    }

    var body: some View {
        Group {
            if authStep == -1 {
                OnboardingView(initialPage: onboardingStartPage) {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        onboardingStartPage = 0
                        authStep = 0
                    }
                }
            } else if authStep == 0 {
                AuthStartView(
                    onBack: {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            onboardingStartPage = 3
                            authStep = -1
                        }
                    },
                    onLogin: {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            authStep = 3
                        }
                    },
                    onSignUp: {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            authStep = 1
                        }
                    }
                )
            } else if authStep == 3 {
                AuthLoginView(
                    onBack: {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            authStep = 0
                        }
                    },
                    onLoginSuccess: {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            authStep = 2
                        }
                    },
                    onSignUp: {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            authStep = 0
                        }
                    },
                    onForgotPassword: {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            authStep = 4
                        }
                    }
                )
            } else if authStep == 4 {
                ForgotPasswordView(
                    onBack: {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            authStep = 3
                        }
                    }
                )
            } else if authStep == 1 {
                SchoolVerificationView(
                    onBack: {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            authStep = 0
                        }
                    },
                    onVerified: {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            authStep = 2
                        }
                    }
                )
            } else {
                mainApp
            }
        }
        .sheet(isPresented: $showingAddCourse) {
            CourseFormView { newCourse in
                courses.append(newCourse)
            }
        }
        .sheet(item: $courseToEdit) { course in
            CourseFormView(course: course) { updatedCourse in
                if let index = courses.firstIndex(where: { $0.id == updatedCourse.id }) {
                    courses[index] = updatedCourse
                }
            }
        }
        .sheet(isPresented: $showingWritePost) {
            WritePostView()
        }
    }

    private var mainApp: some View {

        TabView(selection: $selectedTab) {

            BoardScreen(posts: posts, onWrite: { showingWritePost = true })

                .tabItem { Image(systemName: "list.bullet.rectangle.fill"); Text("게시판") }

                .tag(0)

            ScheduleScreen(

                selectedSemester: $selectedSemester,

                courses: courses,

                uniqueCourses: uniqueCourses,

                nextCourse: nextCourse,

                semesters: semesters,

                days: days,

                dayLabels: dayLabels,

                hours: hours,

                onAdd: { showingAddCourse = true },

                onEdit: { courseToEdit = $0 }

            )

            .tabItem { Image(systemName: "calendar"); Text("시간표") }

            .tag(1)

            CourseRoomScreen(courses: uniqueCourses)

                .tabItem { Image(systemName: "door.left.hand.open"); Text("강의실") }

                .tag(2)

            GPAHelperScreen()

                .tabItem { Image(systemName: "chart.bar.fill"); Text("GPA") }

                .tag(3)

            CampusHelperScreen()

                .tabItem { Image(systemName: "globe.americas.fill"); Text("캠퍼스") }

                .tag(4)

        }

        .tint(BridgeTheme.blue)

    }

}

struct BridgeLogo: View {
    var body: some View {
        HStack(spacing: 10) {
            Image("BridgeLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 36, height: 36)
                .clipShape(Circle())

            Text("Bridge")
                .font(.system(size: 24, weight: .black, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [BridgeTheme.blue, Color(red: 0.48, green: 0.20, blue: 1.0)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
        }
    }
}

struct OnboardingView: View {
    let onFinish: () -> Void
    @State private var page: Int

    init(initialPage: Int = 0, onFinish: @escaping () -> Void) {
        self.onFinish = onFinish
        _page = State(initialValue: initialPage)
    }

    private let pages: [OnboardingPage] = [
        OnboardingPage(
            badge: "For International Students",
            title: "유학생활의 모든 것,\nBridge 하나로.",
            detail: "시간표, 게시판, 강의실, GPA, 캠퍼스 생활정보를 학교별로 한 곳에서 확인해요.",
            icon: "globe.americas.fill"
        ),
        OnboardingPage(
            badge: "Timetable",
            title: "수업과 강의실을\n한눈에 정리해요.",
            detail: "학기별 시간표를 만들고, 다음 수업 시간과 강의실 위치를 바로 확인할 수 있어요.",
            icon: "calendar"
        ),
        OnboardingPage(
            badge: "Community",
            title: "같은 학교 유학생끼리\n질문하고 답해요.",
            detail: "CPT, 룸메이트, 수업 난이도, 학교생활 고민까지 한국어로 편하게 나눌 수 있어요.",
            icon: "bubble.left.and.bubble.right.fill"
        ),
        OnboardingPage(
            badge: "School Verified",
            title: "학교 인증 후\n안전하게 시작해요.",
            detail: "학교 이메일 인증으로 같은 캠퍼스 학생들끼리 안전하게 연결되는 커뮤니티를 만들어요.",
            icon: "checkmark.seal.fill"
        )
    ]

    var body: some View {
        ZStack {
            BridgeTheme.background.ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    BridgeLogo()
                    Spacer()
                    if page < pages.count - 1 {
                        Button("건너뛰기") {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                page = pages.count - 1
                            }
                        }
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(BridgeTheme.muted)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 22)
                .padding(.bottom, 14)

                TabView(selection: $page) {
                    ForEach(pages.indices, id: \.self) { index in
                        OnboardingCard(page: pages[index], isLast: index == pages.count - 1, onFinish: onFinish)
                            .tag(index)
                            .padding(.horizontal, 14)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 620)
                .padding(.bottom, 18)

                HStack(spacing: 8) {
                    ForEach(pages.indices, id: \.self) { index in
                        Capsule()
                            .fill(index == page ? BridgeTheme.blue : BridgeTheme.blue.opacity(0.16))
                            .frame(width: index == page ? 24 : 8, height: 8)
                            .animation(.easeInOut(duration: 0.2), value: page)
                    }
                }
                .padding(.bottom, 18)

                if page < pages.count - 1 {
                    Button {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            page += 1
                        }
                    } label: {
                        Text("다음")
                            .font(.system(size: 16, weight: .black))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(BridgeTheme.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 28)
                } else {
                    VStack(spacing: 12) {
                        Button { onFinish() } label: {
                            Text("로그인 / 회원가입")
                                .font(.system(size: 16, weight: .black))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(BridgeTheme.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        }

                        Text("학교 인증 후 Bridge를 이용할 수 있어요.")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(BridgeTheme.muted)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 26)
                }
            }
        }
    }
}

struct OnboardingPage {
    let badge: String
    let title: String
    let detail: String
    let icon: String
}

struct OnboardingCard: View {
    let page: OnboardingPage
    let isLast: Bool
    let onFinish: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer(minLength: 8)

            VStack(alignment: .leading, spacing: 0) {
                // REMOVED BADGE BLOCK
                Spacer()
                    .frame(height: 8)
                if page.title.contains("Bridge") {
                    Image("BridgeLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 94, height: 94)
                        .clipShape(Circle())
                        .shadow(color: BridgeTheme.blue.opacity(0.14), radius: 18, x: 0, y: 12)
                        .padding(.bottom, 24)
                } else {
                    Image(systemName: page.icon)
                        .font(.system(size: 38, weight: .black))
                        .foregroundStyle(BridgeTheme.blue)
                        .frame(width: 94, height: 94)
                        .background(BridgeTheme.blue.opacity(0.09))
                        .clipShape(Circle())
                        .shadow(color: BridgeTheme.blue.opacity(0.10), radius: 14, x: 0, y: 8)
                        .padding(.bottom, 24)
                }

                OnboardingTitleText(title: page.title)
                    .padding(.bottom, 14)

                Text(page.detail)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundStyle(BridgeTheme.muted)
                    .lineSpacing(6)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, 14)

                OnboardingPreview(page: page)
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .padding(.bottom, 24)
            .frame(maxWidth: .infinity, minHeight: 590, maxHeight: 590, alignment: .topLeading)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 36, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 36, style: .continuous)
                    .stroke(Color.white.opacity(0.9), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.07), radius: 22, x: 0, y: 12)

            Spacer(minLength: 8)
        }
    }
}

struct OnboardingTitleText: View {
    let title: String

    var body: some View {
        if title.contains("Bridge") {
            VStack(alignment: .leading, spacing: 6) {
                Text("유학생활의 모든 것,")
                    .lineLimit(1)
                    .minimumScaleFactor(0.68)

                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text("Bridge")
                        .foregroundStyle(
                            LinearGradient(
                                colors: [BridgeTheme.blue, Color(red: 0.48, green: 0.20, blue: 1.0)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    Text("하나로.")
                }
                .lineLimit(1)
                .minimumScaleFactor(0.72)
            }
            .font(.system(size: 40, weight: .black, design: .rounded))
            .foregroundStyle(BridgeTheme.ink)
            .lineSpacing(-1)
            .fixedSize(horizontal: false, vertical: true)
        } else {
            Text(title)
                .font(.system(size: 42, weight: .black, design: .rounded))
                .foregroundStyle(BridgeTheme.ink)
                .lineSpacing(-1)
                .minimumScaleFactor(0.78)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct OnboardingPreview: View {
    let page: OnboardingPage

    var body: some View {
        if page.title.contains("Bridge") {
            FeaturePreviewGrid()
        } else if page.badge == "Timetable" {
            MiniTimetablePreview()
        } else if page.badge == "Community" {
            MiniCommunityPreview()
        } else {
            MiniVerificationPreview()
        }
    }
}

struct FeaturePreviewGrid: View {
    private let items = [
        ("게시판", "익명 질문", "bubble.left.and.bubble.right.fill"),
        ("시간표", "수업 위치", "calendar"),
        ("강의실", "수업 후기", "star.fill"),
        ("GPA", "학점 계산", "chart.bar.fill"),
        ("캠퍼스", "생활 정보", "megaphone.fill")
    ]

    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            ForEach(items, id: \.0) { item in
                HStack(spacing: 10) {
                    Image(systemName: item.2)
                        .font(.system(size: 13, weight: .black))
                        .foregroundStyle(BridgeTheme.blue)
                        .frame(width: 30, height: 30)
                        .background(BridgeTheme.blue.opacity(0.09))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.0)
                            .font(.system(size: 13, weight: .black, design: .rounded))
                            .foregroundStyle(BridgeTheme.ink)
                        Text(item.1)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(BridgeTheme.muted)
                    }

                    Spacer(minLength: 0)
                }
                .padding(10)
                .background(Color(red: 0.97, green: 0.98, blue: 1.0))
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            }
        }
    }
}

struct MiniCommunityPreview: View {
    private let rows = [
        ("자유 게시판", "오늘 학교 너무 춥지 않나요...", "댓글 12"),
        ("정보 게시판", "SSN 없이 은행 계좌 만들 수 있는 곳 정리", "댓글 21"),
        ("인턴십 게시판", "F-1 학생도 온캠퍼스 잡 지원 가능한가요?", "댓글 5")
    ]

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Community")
                        .font(.system(size: 12, weight: .black))
                        .foregroundStyle(BridgeTheme.blue)
                    Text("게시판 미리보기")
                        .font(.system(size: 20, weight: .black, design: .rounded))
                        .foregroundStyle(BridgeTheme.ink)
                }
                Spacer()
                Text("익명 가능")
                    .font(.system(size: 12, weight: .black))
                    .foregroundStyle(BridgeTheme.muted)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(red: 0.94, green: 0.96, blue: 0.99))
                    .clipShape(Capsule())
            }

            ForEach(rows, id: \.1) { row in
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(row.0)
                            .font(.system(size: 12, weight: .black))
                            .foregroundStyle(BridgeTheme.blue)
                        Text(row.1)
                            .font(.system(size: 14, weight: .black, design: .rounded))
                            .foregroundStyle(BridgeTheme.ink)
                            .lineLimit(1)
                    }
                    Spacer()
                    Text(row.2)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(BridgeTheme.muted)
                }
                .padding(13)
                .background(Color(red: 0.97, green: 0.98, blue: 1.0))
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            }
        }
    }
}

struct MiniTimetablePreview: View {
    private let days = ["Mon", "Tue", "Wed", "Thu", "Fri"]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Timetable")
                        .font(.system(size: 12, weight: .black))
                        .foregroundStyle(BridgeTheme.blue)
                    Text("나의 시간표")
                        .font(.system(size: 20, weight: .black, design: .rounded))
                        .foregroundStyle(BridgeTheme.ink)
                }
                Spacer()
                Text("Fall 2026")
                    .font(.system(size: 12, weight: .black))
                    .foregroundStyle(BridgeTheme.blue)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(BridgeTheme.blue.opacity(0.08))
                    .clipShape(Capsule())
            }

            HStack(spacing: 8) {
                ForEach(days, id: \.self) { day in
                    VStack(spacing: 10) {
                        Text(day)
                            .font(.system(size: 11, weight: .black))
                            .foregroundStyle(BridgeTheme.muted)

                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color(red: 0.97, green: 0.98, blue: 1.0))
                            .frame(height: 118)
                            .overlay(alignment: day == "Tue" || day == "Thu" ? .center : .top) {
                                if day == "Mon" || day == "Wed" {
                                    MiniClassPill(title: "CS 300", color: Color(red: 0.82, green: 0.89, blue: 1.0))
                                        .padding(.top, day == "Mon" ? 20 : 12)
                                } else if day == "Tue" || day == "Thu" {
                                    MiniClassPill(title: "STAT 240", color: Color(red: 0.91, green: 0.84, blue: 1.0))
                                } else {
                                    MiniClassPill(title: "LIS 201", color: Color(red: 0.84, green: 0.96, blue: 0.86))
                                        .padding(.top, 38)
                                }
                            }
                    }
                }
            }
        }
    }
}

struct MiniClassPill: View {
    let title: String
    let color: Color

    var body: some View {
        Text(title)
            .font(.system(size: 11, weight: .black, design: .rounded))
            .foregroundStyle(BridgeTheme.ink)
            .lineLimit(1)
            .padding(.horizontal, 8)
            .padding(.vertical, 7)
            .frame(maxWidth: .infinity)
            .background(color)
            .clipShape(Capsule())
            .padding(.horizontal, 5)
    }
}

struct MiniVerificationPreview: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 18, weight: .black))
                    .foregroundStyle(BridgeTheme.blue)
                    .frame(width: 42, height: 42)
                    .background(BridgeTheme.blue.opacity(0.09))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                VStack(alignment: .leading, spacing: 4) {
                    Text("학교 인증")
                        .font(.system(size: 16, weight: .black, design: .rounded))
                        .foregroundStyle(BridgeTheme.ink)
                    Text("같은 캠퍼스 학생만 연결")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(BridgeTheme.muted)
                }
                Spacer()
            }

            VerificationPreviewRow(text: "학교 이메일로 캠퍼스 확인")
            VerificationPreviewRow(text: "학교별 게시판과 시간표 분리")
            VerificationPreviewRow(text: "익명 게시판은 안전 기준 적용")
        }
        .padding(14)
        .background(Color(red: 0.97, green: 0.98, blue: 1.0))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

struct VerificationPreviewRow: View {
    let text: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(BridgeTheme.blue)
            Text(text)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(BridgeTheme.muted)
            Spacer()
        }
    }
}

struct AuthStartView: View {
    let onBack: () -> Void
    let onLogin: () -> Void
    let onSignUp: () -> Void

    @State private var selectedSchool = "UW-Madison"
    @State private var showSchoolPicker = false
    @State private var schoolEmail = ""
    @State private var password = ""
    @State private var nickname = ""
    @State private var showMissingInfoAlert = false

    private var isWiscEmail: Bool {
        let email = schoolEmail.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return email.hasSuffix("@wisc.edu") && email.contains("@")
    }

    private var isPasswordValid: Bool {
        password.count >= 8
    }

    private var isNicknameValid: Bool {
        !nickname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var canSignUp: Bool {
        isWiscEmail && isPasswordValid && isNicknameValid
    }

    private var validationMessage: String {
        if schoolEmail.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "학교 이메일을 입력해주세요."
        }

        if !isWiscEmail {
            return "UW-Madison 학교 이메일 형식으로 입력해주세요. 예: yourname@wisc.edu"
        }

        if password.isEmpty {
            return "비밀번호를 입력해주세요."
        }

        if !isPasswordValid {
            return "비밀번호는 최소 8자 이상이어야 합니다."
        }

        if !isNicknameValid {
            return "닉네임을 입력해주세요."
        }

        return "입력 정보를 확인해주세요."
    }

    var body: some View {
        ZStack {
            BridgeTheme.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        BridgeLogo()
                            .padding(.top, 18)

                        Spacer()

                        Button("이전") {
                            onBack()
                        }
                        .font(.system(size: 13, weight: .black))
                        .foregroundStyle(BridgeTheme.muted)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 9)
                        .background(.white)
                        .clipShape(Capsule())
                        .padding(.top, 18)
                    }

                    VStack(alignment: .leading, spacing: 18) {
                        Text("회원가입")
                            .font(.system(size: 13, weight: .black))
                            .foregroundStyle(BridgeTheme.blue)

                        Text("Bridge 시작하기")
                            .font(.system(size: 30, weight: .black, design: .rounded))
                            .foregroundStyle(BridgeTheme.ink)

                        Text("학교 이메일로 인증하고 UW-Madison 유학생 커뮤니티에 참여하세요.")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(BridgeTheme.muted)
                            .lineSpacing(4)

                        AuthField(title: "학교 이메일", placeholder: "yourname@wisc.edu", text: $schoolEmail)
                        if !schoolEmail.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isWiscEmail {
                            Text("UW-Madison 이메일은 @wisc.edu 형식이어야 해요.")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundStyle(.red.opacity(0.8))
                        }
                        AuthField(title: "비밀번호", placeholder: "비밀번호 입력", isSecure: true, text: $password)
                        if !password.isEmpty && !isPasswordValid {
                            Text("비밀번호는 최소 8자 이상이어야 해요.")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundStyle(.red.opacity(0.8))
                        }
                        AuthField(title: "닉네임", placeholder: "예: badger2026", text: $nickname)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("학교")
                                .font(.system(size: 14, weight: .black))
                                .foregroundStyle(BridgeTheme.ink)

                            Button {
                                showSchoolPicker = true
                            } label: {
                                HStack {
                                    Text(selectedSchool)
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundStyle(selectedSchool == "School / University" ? BridgeTheme.muted : BridgeTheme.ink)

                                    Spacer()

                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundStyle(BridgeTheme.ink)
                                }
                                .padding(15)
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.black.opacity(0.08), lineWidth: 1))
                            }
                            .buttonStyle(.plain)
                            .confirmationDialog("학교 선택", isPresented: $showSchoolPicker, titleVisibility: .visible) {
                                Button("UW-Madison") {
                                    selectedSchool = "UW-Madison"
                                }

                                Button("취소", role: .cancel) { }
                            }
                        }

                        Button {
                            if canSignUp {
                                onSignUp()
                            } else {
                                showMissingInfoAlert = true
                            }
                        } label: {
                            Text("가입하기")
                                .font(.system(size: 16, weight: .black))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(canSignUp ? BridgeTheme.blue : BridgeTheme.blue.opacity(0.35))
                                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        }
                        .alert("입력 확인", isPresented: $showMissingInfoAlert) {
                            Button("확인", role: .cancel) { }
                        } message: {
                            Text(validationMessage)
                        }

                        HStack {
                            Spacer()
                            Text("이미 계정이 있나요?")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(BridgeTheme.muted)
                            Button("로그인") { onLogin() }
                                .font(.system(size: 13, weight: .black))
                                .foregroundStyle(BridgeTheme.blue)
                            Spacer()
                        }
                    }
                    .padding(22)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
                    .shadow(color: .black.opacity(0.05), radius: 18, x: 0, y: 10)

                    Text("학교 인증 후 같은 학교 학생들만 볼 수 있는 시간표, 게시판, 강의실 정보를 이용할 수 있어요.")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(BridgeTheme.muted)
                        .lineSpacing(4)
                        .padding(.horizontal, 6)
                }
                .padding(24)
            }
        }
    }
}

struct AuthLoginView: View {
    let onBack: () -> Void
    let onLoginSuccess: () -> Void
    let onSignUp: () -> Void
    let onForgotPassword: () -> Void

    @State private var schoolEmail = ""
    @State private var password = ""

    var body: some View {
        ZStack {
            BridgeTheme.background.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    BridgeLogo()
                        .padding(.top, 18)

                    Spacer()

                    Button("이전") {
                        onBack()
                    }
                    .font(.system(size: 13, weight: .black))
                    .foregroundStyle(BridgeTheme.muted)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 9)
                    .background(.white)
                    .clipShape(Capsule())
                    .padding(.top, 18)
                }

                VStack(alignment: .leading, spacing: 18) {
                    Text("로그인")
                        .font(.system(size: 13, weight: .black))
                        .foregroundStyle(BridgeTheme.blue)

                    Text("다시 오신 걸 환영해요")
                        .font(.system(size: 30, weight: .black, design: .rounded))
                        .foregroundStyle(BridgeTheme.ink)

                    Text("학교생활 정보, 시간표, 게시판을 계속 확인하세요.")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(BridgeTheme.muted)
                        .lineSpacing(4)

                    AuthField(title: "학교 이메일", placeholder: "yourname@school.edu", text: $schoolEmail)
                    AuthField(title: "비밀번호", placeholder: "비밀번호 입력", isSecure: true, text: $password)

                    Button { onLoginSuccess() } label: {
                        Text("로그인")
                            .font(.system(size: 16, weight: .black))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(BridgeTheme.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }
                    .padding(.top, 2)

                    HStack {
                        Button("회원가입") { onSignUp() }
                            .font(.system(size: 13, weight: .black))
                            .foregroundStyle(BridgeTheme.blue)

                        Spacer()

                        Button("비밀번호 찾기") {
                            onForgotPassword()
                        }
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(BridgeTheme.muted)
                    }
                }
                .padding(22)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
                .shadow(color: .black.opacity(0.05), radius: 18, x: 0, y: 10)

                Spacer()
            }
            .padding(24)
        }
    }
}

struct ForgotPasswordView: View {
    let onBack: () -> Void

    @State private var schoolEmail = ""
    @State private var showResetSentAlert = false
    @State private var showInvalidEmailAlert = false

    private var isWiscEmail: Bool {
        let email = schoolEmail.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return email.hasSuffix("@wisc.edu") && email.contains("@")
    }

    var body: some View {
        ZStack {
            BridgeTheme.background.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    BridgeLogo()
                        .padding(.top, 18)

                    Spacer()

                    Button("이전") {
                        onBack()
                    }
                    .font(.system(size: 13, weight: .black))
                    .foregroundStyle(BridgeTheme.muted)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 9)
                    .background(.white)
                    .clipShape(Capsule())
                    .padding(.top, 18)
                }

                VStack(alignment: .leading, spacing: 18) {
                    Text("비밀번호 찾기")
                        .font(.system(size: 13, weight: .black))
                        .foregroundStyle(BridgeTheme.blue)

                    Text("비밀번호를 재설정할게요")
                        .font(.system(size: 30, weight: .black, design: .rounded))
                        .foregroundStyle(BridgeTheme.ink)

                    Text("가입한 학교 이메일을 입력하면 비밀번호 재설정 링크를 보내드려요.")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(BridgeTheme.muted)
                        .lineSpacing(4)

                    AuthField(title: "학교 이메일", placeholder: "yourname@wisc.edu", text: $schoolEmail)

                    if !schoolEmail.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isWiscEmail {
                        Text("UW-Madison 이메일은 @wisc.edu 형식이어야 해요.")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.red.opacity(0.8))
                    }

                    Button {
                        if isWiscEmail {
                            showResetSentAlert = true
                        } else {
                            showInvalidEmailAlert = true
                        }
                    } label: {
                        Text("재설정 링크 보내기")
                            .font(.system(size: 16, weight: .black))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(isWiscEmail ? BridgeTheme.blue : BridgeTheme.blue.opacity(0.35))
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }
                    .padding(.top, 2)
                    .alert("이메일을 확인해주세요", isPresented: $showResetSentAlert) {
                        Button("확인") {
                            onBack()
                        }
                    } message: {
                        Text("비밀번호 재설정 링크를 학교 이메일로 보냈어요.")
                    }
                    .alert("입력 확인", isPresented: $showInvalidEmailAlert) {
                        Button("확인", role: .cancel) { }
                    } message: {
                        Text("UW-Madison 학교 이메일 형식으로 입력해주세요. 예: yourname@wisc.edu")
                    }

                    Text("링크가 오지 않으면 스팸함을 확인하거나 잠시 후 다시 시도해주세요.")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(BridgeTheme.muted)
                        .lineSpacing(3)
                }
                .padding(22)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
                .shadow(color: .black.opacity(0.05), radius: 18, x: 0, y: 10)

                Spacer()
            }
            .padding(24)
        }
    }
}

struct SchoolVerificationView: View {
    let onBack: () -> Void
    let onVerified: () -> Void
    @State private var code = ""

    var body: some View {
        ZStack {
            BridgeTheme.background.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    BridgeLogo()
                    Spacer()
                    Button("이전") {
                        onBack()
                    }
                    .font(.system(size: 13, weight: .black))
                    .foregroundStyle(BridgeTheme.muted)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 9)
                    .background(.white)
                    .clipShape(Capsule())
                }

                VStack(alignment: .leading, spacing: 18) {
                    Text("학교 인증")
                        .font(.system(size: 13, weight: .black))
                        .foregroundStyle(BridgeTheme.blue)

                    Text("학교 이메일 인증")
                        .font(.system(size: 30, weight: .black, design: .rounded))
                        .foregroundStyle(BridgeTheme.ink)

                    Text("학교 이메일로 보낸 인증 코드를 입력하면 Bridge 커뮤니티에 들어갈 수 있어요.")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(BridgeTheme.muted)
                        .lineSpacing(4)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("인증 코드")
                            .font(.system(size: 14, weight: .black))
                            .foregroundStyle(BridgeTheme.ink)

                        TextField("6자리 코드 입력", text: $code)
                            .font(.system(size: 18, weight: .black, design: .rounded))
                            .keyboardType(.numberPad)
                            .padding(16)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.black.opacity(0.08), lineWidth: 1))
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        VerificationPoint(text: "UW-Madison 학생들만 해당 캠퍼스 커뮤니티에 참여할 수 있어요.")
                        VerificationPoint(text: "학교 이메일은 인증 용도로만 사용돼요.")
                        VerificationPoint(text: "익명 게시글도 안전한 운영을 위해 시스템에는 기록될 수 있어요.")
                    }
                    .padding(16)
                    .background(BridgeTheme.blue.opacity(0.06))
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

                    Button { onVerified() } label: {
                        Text("인증하고 시작하기")
                            .font(.system(size: 16, weight: .black))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(BridgeTheme.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }

                    Button("인증 메일 다시 보내기") { }
                        .font(.system(size: 14, weight: .black))
                        .foregroundStyle(BridgeTheme.blue)
                        .frame(maxWidth: .infinity)
                }
                .padding(22)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
                .shadow(color: .black.opacity(0.05), radius: 18, x: 0, y: 10)

                Spacer()
            }
            .padding(24)
        }
    }
}

struct AuthField: View {
    let title: String
    let placeholder: String
    var isSecure: Bool = false
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .black))
                .foregroundStyle(BridgeTheme.ink)

            if isSecure {
                SecureField(placeholder, text: $text)
                    .padding(15)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.black.opacity(0.08), lineWidth: 1))
            } else {
                TextField(placeholder, text: $text)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding(15)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.black.opacity(0.08), lineWidth: 1))
            }
        }
    }
}

struct VerificationPoint: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(BridgeTheme.blue)
            Text(text)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(BridgeTheme.muted)
        }
    }
}

struct LandingView: View {

    let onStart: () -> Void

    var body: some View {

        ZStack {

            Color.white.ignoresSafeArea()

            ScrollView {

                VStack(alignment: .leading, spacing: 28) {

                    HStack {

                        BridgeLogo()

                        Spacer()

                        Button("로그인") { onStart() }

                            .font(.system(size: 13, weight: .bold))

                            .foregroundStyle(BridgeTheme.ink)

                        Button("시작하기") { onStart() }

                            .font(.system(size: 13, weight: .black))

                            .foregroundStyle(.white)

                            .padding(.horizontal, 17)

                            .padding(.vertical, 10)

                            .background(BridgeTheme.blue)

                            .clipShape(Capsule())

                    }

                    VStack(alignment: .leading, spacing: 16) {

                        Text("For international students")

                            .font(.system(size: 13, weight: .black))

                            .foregroundStyle(BridgeTheme.blue)

                            .padding(.horizontal, 12)

                            .padding(.vertical, 8)

                            .background(BridgeTheme.blue.opacity(0.08))

                            .clipShape(Capsule())

                        VStack(alignment: .leading, spacing: 2) {

                            Text("유학생활의")

                            Text("모든 것,")

                            HStack(spacing: 8) {

                            Text("Bridge")

                                .foregroundStyle(BridgeTheme.blue)

                                Text("하나로.")

                            }

                        }

                        .font(.system(size: 47, weight: .black, design: .rounded))

                        .foregroundStyle(BridgeTheme.ink)

                        .lineSpacing(-2)

                        Text("시간표, 익명 게시판, 수업 후기, 룸메이트, 인턴십, 맛집과 생활정보까지. Bridge는 미국 유학생을 위한 한국어 기반 캠퍼스 커뮤니티입니다.")

                            .font(.system(size: 16, weight: .semibold))

                            .foregroundStyle(BridgeTheme.muted)

                            .lineSpacing(5)

                        Button { onStart() } label: {

                            Text("Bridge 시작하기")

                                .font(.system(size: 16, weight: .black))

                                .foregroundStyle(.white)

                                .frame(maxWidth: .infinity)

                                .padding(.vertical, 16)

                                .background(BridgeTheme.blue)

                                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

                        }

                    }

                    LandingPreviewCard()

                    LandingMiniCards()

                }

                .padding(24)

            }

        }

    }

}

struct LandingPreviewCard: View {

    var body: some View {

        VStack(alignment: .leading, spacing: 14) {

            HStack {

                VStack(alignment: .leading, spacing: 4) {

                    Text("Bridge")

                        .font(.system(size: 11, weight: .bold))

                        .foregroundStyle(BridgeTheme.muted)

                    Text("오늘의 캠퍼스")

                        .font(.system(size: 20, weight: .black, design: .rounded))

                }

                Spacer()

                Text("인증됨")

                    .font(.system(size: 11, weight: .black))

                    .foregroundStyle(Color.green)

                    .padding(.horizontal, 9)

                    .padding(.vertical, 6)

                    .background(Color.green.opacity(0.12))

                    .clipShape(Capsule())

            }

            VStack(alignment: .leading, spacing: 8) {

                Text("다음 수업")

                    .font(.system(size: 12, weight: .black))

                    .foregroundStyle(.white.opacity(0.75))

                Text("LIS 201")

                    .font(.system(size: 24, weight: .black, design: .rounded))

                    .foregroundStyle(.white)

                Text("10:00 AM · Helen C. White Hall")

                    .font(.system(size: 13, weight: .bold))

                    .foregroundStyle(.white.opacity(0.75))

            }

            .padding(17)

            .frame(maxWidth: .infinity, alignment: .leading)

            .background(BridgeTheme.blue)

            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

            VStack(spacing: 10) {

                PreviewPost(category: "비자 · CPT / OPT", title: "CPT 신청은 보통 얼마나 걸리나요?")

                PreviewPost(category: "수업 · 전공", title: "CS 300 유학생이 듣기 괜찮나요?")

                PreviewPost(category: "맛집 · 생활정보", title: "매디슨 근처 한식 추천해주세요.")

            }

        }

        .padding(18)

        .background(BridgeTheme.background)

        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))

        .overlay(RoundedRectangle(cornerRadius: 28, style: .continuous).stroke(Color.black.opacity(0.05), lineWidth: 1))

        .shadow(color: .black.opacity(0.06), radius: 22, x: 0, y: 12)

    }

}

struct PreviewPost: View {

    let category: String

    let title: String

    var body: some View {

        VStack(alignment: .leading, spacing: 5) {

            Text(category)

                .font(.system(size: 11, weight: .black))

                .foregroundStyle(BridgeTheme.blue)

            Text(title)

                .font(.system(size: 14, weight: .black))

                .foregroundStyle(BridgeTheme.ink)

        }

        .padding(14)

        .frame(maxWidth: .infinity, alignment: .leading)

        .background(.white)

        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

    }

}

struct LandingMiniCards: View {

    var body: some View {

        VStack(spacing: 10) {

            HStack(spacing: 10) {

                MiniInfoCard(label: "첫 시작", title: "Campus Community", detail: "학교별 유학생 커뮤니티")

                MiniInfoCard(label: "학교 인증", title: ".edu 이메일", detail: "학교 이메일 인증 후 같은 캠퍼스 연결")

            }

            MiniInfoCard(label: "핵심 기능", title: "시간표 + 게시판", detail: "수업, 교수, 룸메이트, 생활정보를 한국어로 확인")

        }

    }

}

struct MiniInfoCard: View {

    let label: String

    let title: String

    let detail: String

    var body: some View {

        VStack(alignment: .leading, spacing: 6) {

            Text(label)

                .font(.system(size: 11, weight: .black))

                .foregroundStyle(BridgeTheme.blue)

            Text(title)

                .font(.system(size: 16, weight: .black, design: .rounded))

                .foregroundStyle(BridgeTheme.ink)

            Text(detail)

                .font(.system(size: 12, weight: .semibold))

                .foregroundStyle(BridgeTheme.muted)

                .lineLimit(2)

        }

        .padding(14)

        .frame(maxWidth: .infinity, alignment: .leading)

        .background(.white)

        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.black.opacity(0.06), lineWidth: 1))

    }

}

struct BoardScreen: View {

    let posts: [BoardPost]

    let onWrite: () -> Void

    @State private var selectedBoardTab = "홈"
    @State private var selectedRankingFilter = "실시간"

    var body: some View {

        NavigationStack {

            ZStack {

                BridgeTheme.background.ignoresSafeArea()

                ScrollView {

                    VStack(spacing: 14) {

                        AppHeader(actionTitle: "글쓰기", action: onWrite, showSearch: true)

                        BoardTopTabs(selected: $selectedBoardTab)

                        if selectedBoardTab == "홈" {
                            BoardFeatureCarousel()
                            BoardFilterChips(selected: $selectedRankingFilter)
                            BoardTrendingList(filter: selectedRankingFilter)
                        } else {
                            BoardPostListScreen(tab: selectedBoardTab)
                        }

                    }

                    .padding(.horizontal, 18)

                    .padding(.top, 12)

                    .padding(.bottom, 28)

                }

            }

            .navigationBarHidden(true)

        }

    }

}

struct AppHeader: View {

    let actionTitle: String

    let action: () -> Void

    var showSearch: Bool = false

    var body: some View {

        HStack(spacing: 12) {

            BridgeLogo()

            Spacer()

            if showSearch {
                Button {
                    // Search action will be connected later.
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 16, weight: .black))
                        .foregroundStyle(BridgeTheme.muted)
                        .frame(width: 42, height: 42)
                        .background(.white)
                        .clipShape(Circle())
                }
            }

            Button(actionTitle) { action() }

                .font(.system(size: 13, weight: .black))

                .foregroundStyle(.white)

                .padding(.horizontal, 16)

                .padding(.vertical, 10)

                .background(BridgeTheme.blue)

                .clipShape(Capsule())

        }

    }

}

struct BoardHero: View {

    var body: some View {

        VStack(alignment: .leading, spacing: 14) {

            Text("Campus Community")
                .font(.system(size: 12, weight: .black))
                .foregroundStyle(.white.opacity(0.85))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.white.opacity(0.12))
                .clipShape(Capsule())

            Text("게시판")
                .font(.system(size: 34, weight: .black, design: .rounded))
                .foregroundStyle(.white)

            Text("학교생활 질문과 정보를 익명으로 편하게 나눠요.")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white.opacity(0.86))
                .lineSpacing(4)

        }
        .padding(.horizontal, 24)
        .padding(.vertical, 22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(BridgeTheme.blue)
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        .shadow(color: BridgeTheme.blue.opacity(0.18), radius: 22, x: 0, y: 12)
    }

}

struct BoardFeatureCarousel: View {
    @State private var selectedPage = 0

    private let cards = [
        BoardFeatureCardData(
            label: "Hot",
            title: "CPT 신청 전\n꼭 확인할 것",
            meta: "익명 · 3일 전 · 조회337 · 댓글5",
            symbol: "doc.text.fill",
            iconColor: Color(red: 0.12, green: 0.36, blue: 0.95),
            iconBackground: .white.opacity(0.92),
            colors: [Color(red: 0.98, green: 0.38, blue: 0.62), Color(red: 1.0, green: 0.73, blue: 0.62)]
        ),
        BoardFeatureCardData(
            label: "Hot",
            title: "룸메이트 계약\n주의할 점 정리",
            meta: "badger2026 · 1일 전 · 조회210 · 댓글21",
            symbol: "house.fill",
            iconColor: Color(red: 0.98, green: 0.33, blue: 0.55),
            iconBackground: .white.opacity(0.92),
            colors: [Color(red: 0.36, green: 0.60, blue: 0.98), Color(red: 0.68, green: 0.86, blue: 1.0)]
        ),
        BoardFeatureCardData(
            label: "Hot",
            title: "수강신청 때\n실수하면 안 되는 것",
            meta: "익명 · 5시간 전 · 조회198 · 댓글8",
            symbol: "calendar.badge.clock",
            iconColor: Color(red: 1.0, green: 0.58, blue: 0.04),
            iconBackground: .white.opacity(0.92),
            colors: [Color(red: 1.0, green: 0.67, blue: 0.20), Color(red: 1.0, green: 0.88, blue: 0.35)]
        ),
        BoardFeatureCardData(
            label: "Hot",
            title: "SSN 없이 은행\n계좌 만드는 법",
            meta: "rein_badger · 방금 전 · 조회156 · 댓글12",
            symbol: "creditcard.fill",
            iconColor: Color(red: 0.50, green: 0.25, blue: 1.0),
            iconBackground: .white.opacity(0.92),
            colors: [Color(red: 0.54, green: 0.44, blue: 1.0), Color(red: 0.76, green: 0.70, blue: 1.0)]
        )
    ]

    var body: some View {
        TabView(selection: $selectedPage) {
            ForEach(cards.indices, id: \.self) { index in
                BoardFeatureCard(card: cards[index])
                    .tag(index)
                    .padding(.horizontal, 2)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: 176)
        .overlay(alignment: .bottom) {
            HStack(spacing: 5) {
                ForEach(cards.indices, id: \.self) { index in
                    Capsule()
                        .fill(index == selectedPage ? .white : .white.opacity(0.45))
                        .frame(width: index == selectedPage ? 16 : 5, height: 5)
                        .animation(.easeInOut(duration: 0.2), value: selectedPage)
                }
            }
            .padding(.bottom, 14)
        }
    }
}

struct BoardFeatureCardData {
    let label: String
    let title: String
    let meta: String
    let symbol: String
    let iconColor: Color
    let iconBackground: Color
    let colors: [Color]
}

struct BoardFeatureCard: View {
    let card: BoardFeatureCardData

    var body: some View {
        ZStack(alignment: .leading) {
            LinearGradient(colors: card.colors, startPoint: .topLeading, endPoint: .bottomTrailing)

            HStack {
                VStack(alignment: .leading, spacing: 14) {
                    Text(card.label)
                        .font(.system(size: 13, weight: .black, design: .rounded))
                        .foregroundStyle(BridgeTheme.blue)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 8)
                        .background(.white.opacity(0.92))
                        .clipShape(Capsule())

                    Text(card.title)
                        .font(.system(size: 24, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                        .lineSpacing(2)
                        .minimumScaleFactor(0.85)

                    Text(card.meta)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.86))
                        .lineLimit(1)
                }

                Spacer()

                ZStack {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(card.iconBackground)
                        .frame(width: 102, height: 102)
                        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 8)

                    Image(systemName: card.symbol)
                        .font(.system(size: 48, weight: .black))
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(card.iconColor, card.iconColor.opacity(0.28))
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
        }
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: .black.opacity(0.07), radius: 16, x: 0, y: 8)
    }
}

struct BoardNoticeTicker: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                NoticePill(text: "확인해주세요 ⭐ ✅")
                NoticePill(text: "#Bridge ⭐ 이용 가이드")
                NoticePill(text: "UW-Madison 인증 안내")
            }
            .padding(.horizontal, 4)
        }
        .padding(.vertical, 10)
        .background(
            LinearGradient(
                colors: [Color.black.opacity(0.92), Color.black.opacity(0.82)],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct NoticePill: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 13, weight: .black, design: .rounded))
            .foregroundStyle(.white)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(.white.opacity(0.08))
            .clipShape(Capsule())
    }
}

struct BoardTopTabs: View {
    @Binding var selected: String
    private let tabs = ["홈", "전체", "비밀", "정보", "룸메이트", "인턴십"]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(tabs, id: \.self) { tab in
                    Button {
                        selected = tab
                    } label: {
                        VStack(spacing: 8) {
                            Text(tab)
                                .font(.system(size: 15, weight: .black, design: .rounded))
                                .foregroundStyle(selected == tab ? BridgeTheme.ink : BridgeTheme.muted)

                            Capsule()
                                .fill(selected == tab ? BridgeTheme.blue : Color.clear)
                                .frame(width: 26, height: 4)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 2)
        }
        .padding(.top, 2)
    }
}

struct BoardFilterChips: View {
    @Binding var selected: String
    private let chips = ["실시간", "TODAY", "1학년", "2학년", "3학년", "4학년", "대학원생"]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(chips, id: \.self) { chip in
                    Button {
                        selected = chip
                    } label: {
                        Text(chip)
                            .font(.system(size: 14, weight: .black, design: .rounded))
                            .foregroundStyle(selected == chip ? .white : BridgeTheme.ink)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 10)
                            .background(selected == chip ? BridgeTheme.blue : .white)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(selected == chip ? Color.clear : Color.black.opacity(0.07), lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 2)
        }
    }
}

struct BoardTrendingList: View {
    let filter: String

    private var items: [BoardTrendingItem] {
        switch filter {
        case "TODAY":
            return [
                BoardTrendingItem(rank: 1, title: "오늘 State St 쪽 사람 많은가요?", meta: "익명 · 2시간 전 · 조회188 · 추천6", commentCount: 18, tag: "자유"),
                BoardTrendingItem(rank: 2, title: "오늘 저녁 같이 밥 먹을 사람 있나요?", meta: "campus_mate · 3시간 전 · 조회144 · 추천4", commentCount: 9, tag: "자유"),
                BoardTrendingItem(rank: 3, title: "오늘 과제 마감 착각한 사람 저뿐인가요", meta: "익명 · 4시간 전 · 조회132 · 추천3", commentCount: 7, tag: "수업")
            ]
        case "1학년":
            return [
                BoardTrendingItem(rank: 1, title: "1학년이 듣기 괜찮은 교양 추천해주세요", meta: "fresh_badger · 8시간 전 · 조회201 · 추천5", commentCount: 14, tag: "수업"),
                BoardTrendingItem(rank: 2, title: "기숙사 생활 처음인데 꼭 챙길 것 있나요?", meta: "익명 · 10시간 전 · 조회178 · 추천8", commentCount: 11, tag: "생활정보"),
                BoardTrendingItem(rank: 3, title: "첫 학기 수강신청 너무 어려운데 조언 부탁해요", meta: "익명 · 12시간 전 · 조회156 · 추천3", commentCount: 9, tag: "수업")
            ]
        case "2학년":
            return [
                BoardTrendingItem(rank: 1, title: "CS 300이랑 STAT 같이 들어도 괜찮나요?", meta: "sophomore26 · 6시간 전 · 조회244 · 추천6", commentCount: 22, tag: "수업"),
                BoardTrendingItem(rank: 2, title: "전공 바꾸는 타이밍 늦은 건가요?", meta: "익명 · 9시간 전 · 조회190 · 추천4", commentCount: 16, tag: "전공"),
                BoardTrendingItem(rank: 3, title: "2학년 때 인턴 준비 뭐부터 해야 하나요?", meta: "badger2026 · 11시간 전 · 조회177 · 추천7", commentCount: 12, tag: "인턴십")
            ]
        case "3학년":
            return [
                BoardTrendingItem(rank: 1, title: "여름 인턴 지원 아직 늦지 않았나요?", meta: "junior_badger · 5시간 전 · 조회266 · 추천9", commentCount: 24, tag: "인턴십"),
                BoardTrendingItem(rank: 2, title: "전공 수업이랑 인터뷰 준비 병행하는 법", meta: "익명 · 7시간 전 · 조회198 · 추천5", commentCount: 13, tag: "커리어"),
                BoardTrendingItem(rank: 3, title: "3학년 때 GPA 올리기 현실적으로 가능할까요?", meta: "campus_mate · 13시간 전 · 조회165 · 추천2", commentCount: 8, tag: "GPA")
            ]
        case "4학년":
            return [
                BoardTrendingItem(rank: 1, title: "OPT 신청 전에 꼭 확인해야 하는 것 정리", meta: "senior_badger · 4시간 전 · 조회312 · 추천11", commentCount: 27, tag: "비자"),
                BoardTrendingItem(rank: 2, title: "졸업 전 마지막 학기 수업 줄이는 게 좋을까요?", meta: "익명 · 9시간 전 · 조회174 · 추천4", commentCount: 10, tag: "수업"),
                BoardTrendingItem(rank: 3, title: "졸업 후 Madison에 남는 사람들 있나요?", meta: "rein_badger · 12시간 전 · 조회141 · 추천3", commentCount: 6, tag: "자유")
            ]
        case "대학원생":
            return [
                BoardTrendingItem(rank: 1, title: "TA 하면서 수업 병행하는 팁 있나요?", meta: "grad_mate · 6시간 전 · 조회155 · 추천5", commentCount: 13, tag: "대학원"),
                BoardTrendingItem(rank: 2, title: "랩 미팅 영어 발표 준비 어떻게 하세요?", meta: "익명 · 8시간 전 · 조회132 · 추천3", commentCount: 9, tag: "대학원"),
                BoardTrendingItem(rank: 3, title: "대학원생 보험이랑 UHS 사용 정리", meta: "campus_mate · 1일 전 · 조회121 · 추천6", commentCount: 7, tag: "생활정보")
            ]
        default:
            return [
                BoardTrendingItem(rank: 1, title: "CPT 신청 전에 advisor 확인 꼭 해야 하나요?", meta: "익명 · 15시간 전 · 조회496 · 추천0", commentCount: 41, tag: "비자"),
                BoardTrendingItem(rank: 2, title: "룸메이트랑 계약 문제 생겼는데 조언 부탁해요", meta: "badger2026 · 17시간 전 · 조회241 · 추천7", commentCount: 5, tag: "룸메이트"),
                BoardTrendingItem(rank: 3, title: "CS 300 유학생이 듣기 괜찮은 수업인가요?", meta: "익명 · 9시간 전 · 조회223 · 추천1", commentCount: 3, tag: "수업"),
                BoardTrendingItem(rank: 4, title: "SSN 없이 은행 계좌 만들 수 있는 곳 정리", meta: "campus_mate · 6시간 전 · 조회188 · 추천4", commentCount: 12, tag: "생활정보")
            ]
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 6) {
                Text("지금 핫한")
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .foregroundStyle(BridgeTheme.ink)
                Text("Bridge 랭킹")
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .foregroundStyle(BridgeTheme.blue)
                Text("⚡")
                    .font(.system(size: 22, weight: .black))
            }
            .padding(.horizontal, 2)
            .padding(.bottom, 14)

            ForEach(items) { item in
                BoardTrendingRow(item: item)

                if item.id != items.last?.id {
                    Divider()
                        .padding(.leading, 44)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct BoardTrendingItem: Identifiable {
    let id: String
    let authorId: String
    let displayName: String
    let isAnonymous: Bool
    let rank: Int
    let title: String
    let body: String
    let meta: String
    let commentCount: Int
    let viewCount: Int
    let likeCount: Int
    let tag: String

    init(
        id: String = UUID().uuidString,
        authorId: String = "user_demo_001",
        displayName: String = "익명",
        isAnonymous: Bool = true,
        rank: Int,
        title: String,
        body: String = "제가 준비하면서 알게 된 내용을 공유해요. 혹시 비슷한 경험이 있거나 더 정확한 정보가 있으면 댓글로 알려주세요.",
        meta: String,
        commentCount: Int,
        viewCount: Int = 0,
        likeCount: Int = 0,
        tag: String
    ) {
        self.id = id
        self.authorId = authorId
        self.displayName = displayName
        self.isAnonymous = isAnonymous
        self.rank = rank
        self.title = title
        self.body = body
        self.meta = meta
        self.commentCount = commentCount
        self.viewCount = viewCount
        self.likeCount = likeCount
        self.tag = tag
    }
}

struct BoardTrendingRow: View {
    let item: BoardTrendingItem

    var body: some View {
        NavigationLink {
            BoardPostDetailView(item: item)
        } label: {
            HStack(alignment: .center, spacing: 12) {
                Text("\(item.rank)")
                    .font(.system(size: 17, weight: .black, design: .rounded))
                    .foregroundStyle(BridgeTheme.blue)
                    .frame(width: 24)

                VStack(alignment: .leading, spacing: 7) {
                    HStack(spacing: 6) {
                        Text(item.tag)
                            .font(.system(size: 11, weight: .black))
                            .foregroundStyle(BridgeTheme.blue)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(BridgeTheme.blue.opacity(0.08))
                            .clipShape(Capsule())

                        Spacer(minLength: 0)
                    }

                    Text(item.title)
                        .font(.system(size: 16, weight: .black, design: .rounded))
                        .foregroundStyle(BridgeTheme.ink)
                        .lineLimit(2)

                    Text(item.meta)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(BridgeTheme.muted)
                }

                Spacer()

                VStack(spacing: 2) {
                    Text("\(item.commentCount)")
                        .font(.system(size: 18, weight: .black, design: .rounded))
                        .foregroundStyle(BridgeTheme.ink)
                    Text("댓글")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(BridgeTheme.muted)
                }
                .frame(width: 58, height: 58)
                .background(Color(red: 0.96, green: 0.97, blue: 0.99))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 16)
        }
        .buttonStyle(.plain)
    }
}

struct BoardPostListScreen: View {
    let tab: String

    private var posts: [BoardTrendingItem] {
        switch tab {
        case "비밀":
            return [
                BoardTrendingItem(rank: 0, title: "룸메이트랑 생활 패턴이 너무 안 맞을 때 어떻게 해요?", meta: "익명 · 방금 전 · 조회42 · 댓글6", commentCount: 6, tag: "비밀"),
                BoardTrendingItem(rank: 0, title: "학교생활이 생각보다 외로운데 다들 어떻게 버텨요?", meta: "익명 · 18분 전 · 조회58 · 댓글9", commentCount: 9, tag: "비밀"),
                BoardTrendingItem(rank: 0, title: "수업에서 영어 때문에 발표가 너무 부담돼요", meta: "익명 · 36분 전 · 조회67 · 댓글7", commentCount: 7, tag: "비밀")
            ]
        case "정보":
            return [
                BoardTrendingItem(rank: 0, title: "CPT 신청 타임라인 정리해봤어요", meta: "익명 · 15시간 전 · 조회496 · 댓글41", commentCount: 41, tag: "정보"),
                BoardTrendingItem(rank: 0, title: "SSN 없이 은행 계좌 만들 수 있는 곳 정리", meta: "campus_mate · 1일 전 · 조회312 · 댓글27", commentCount: 27, tag: "정보"),
                BoardTrendingItem(rank: 0, title: "SHIP 보험으로 받을 수 있는 서비스 정리", meta: "익명 · 2일 전 · 조회188 · 댓글9", commentCount: 9, tag: "정보")
            ]
        case "룸메이트":
            return [
                BoardTrendingItem(rank: 0, title: "룸메이트랑 계약 문제 생겼는데 조언 부탁해요", meta: "badger2026 · 17시간 전 · 조회241 · 댓글5", commentCount: 5, tag: "룸메이트"),
                BoardTrendingItem(rank: 0, title: "8월 입주 룸메이트 구하는 사람 있나요?", meta: "rein_badger · 1일 전 · 조회156 · 댓글12", commentCount: 12, tag: "룸메이트"),
                BoardTrendingItem(rank: 0, title: "룸메이트 생활규칙 처음에 뭐 정해야 하나요?", meta: "익명 · 2일 전 · 조회98 · 댓글7", commentCount: 7, tag: "룸메이트")
            ]
        case "인턴십":
            return [
                BoardTrendingItem(rank: 0, title: "2학년 때 인턴 준비 뭐부터 해야 하나요?", meta: "badger2026 · 11시간 전 · 조회177 · 댓글12", commentCount: 12, tag: "인턴십"),
                BoardTrendingItem(rank: 0, title: "F-1 학생 resume에 visa status 써야 하나요?", meta: "익명 · 1일 전 · 조회201 · 댓글14", commentCount: 14, tag: "인턴십"),
                BoardTrendingItem(rank: 0, title: "학교 안에서 할 수 있는 마케팅 잡 추천해주세요", meta: "campus_mate · 2일 전 · 조회122 · 댓글6", commentCount: 6, tag: "인턴십")
            ]
        default:
            return [
                BoardTrendingItem(rank: 0, title: "CPT 신청 전에 advisor 확인 꼭 해야 하나요?", meta: "익명 · 15시간 전 · 조회496 · 댓글41", commentCount: 41, tag: "비자"),
                BoardTrendingItem(rank: 0, title: "룸메이트랑 계약 문제 생겼는데 조언 부탁해요", meta: "badger2026 · 17시간 전 · 조회241 · 댓글5", commentCount: 5, tag: "룸메이트"),
                BoardTrendingItem(rank: 0, title: "CS 300 유학생이 듣기 괜찮은 수업인가요?", meta: "익명 · 9시간 전 · 조회223 · 댓글3", commentCount: 3, tag: "수업"),
                BoardTrendingItem(rank: 0, title: "SSN 없이 은행 계좌 만들 수 있는 곳 정리", meta: "campus_mate · 6시간 전 · 조회188 · 댓글12", commentCount: 12, tag: "생활정보"),
                BoardTrendingItem(rank: 0, title: "오늘 State St 쪽 사람 많은가요?", meta: "익명 · 2시간 전 · 조회188 · 댓글18", commentCount: 18, tag: "자유")
            ]
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            ForEach(posts) { post in
                BoardPostListRow(item: post)

                if post.id != posts.last?.id {
                    Divider()
                        .padding(.leading, 14)
                }
            }
        }
        .padding(.top, 4)
    }
}

struct BoardPostListRow: View {
    let item: BoardTrendingItem

    var body: some View {
        NavigationLink {
            BoardPostDetailView(item: item)
        } label: {
            HStack(alignment: .center, spacing: 12) {
                VStack(alignment: .leading, spacing: 7) {
                    Text(item.tag)
                        .font(.system(size: 11, weight: .black))
                        .foregroundStyle(BridgeTheme.blue)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(BridgeTheme.blue.opacity(0.08))
                        .clipShape(Capsule())

                    Text(item.title)
                        .font(.system(size: 17, weight: .black, design: .rounded))
                        .foregroundStyle(BridgeTheme.ink)
                        .lineLimit(2)

                    Text(item.meta)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(BridgeTheme.muted)
                }

                Spacer()

                VStack(spacing: 2) {
                    Text("\(item.commentCount)")
                        .font(.system(size: 18, weight: .black, design: .rounded))
                        .foregroundStyle(BridgeTheme.ink)
                    Text("댓글")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(BridgeTheme.muted)
                }
                .frame(width: 56, height: 56)
                .background(Color(red: 0.96, green: 0.97, blue: 0.99))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 16)
        }
        .buttonStyle(.plain)
    }
}

struct BoardPostDetailView: View {
    let item: BoardTrendingItem

    private var visibleAuthor: String {
        item.isAnonymous ? "익명" : item.displayName
    }

    private var sampleComments: [PostComment] {
        [
            PostComment(id: "comment_001", authorId: "user_comment_001", displayName: "익명", isAnonymous: true, body: "저도 이거 궁금했어요. 정보 공유 감사합니다.", likeCount: 0, createdText: "12분 전"),
            PostComment(id: "comment_002", authorId: "user_comment_002", displayName: "badger2026", isAnonymous: false, body: "저는 비슷한 상황이었는데 advisor에게 먼저 이메일 보내는 게 제일 빨랐어요.", likeCount: 1, createdText: "8분 전"),
            PostComment(id: "comment_003", authorId: "user_comment_003", displayName: "익명", isAnonymous: true, body: "학교마다 조금 다를 수 있어서 ISS 페이지도 같이 확인하는 걸 추천해요.", likeCount: 0, createdText: "방금 전")
        ]
    }

    var body: some View {
        ZStack {
            BridgeTheme.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Text(item.tag)
                                .font(.system(size: 12, weight: .black))
                                .foregroundStyle(BridgeTheme.blue)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(BridgeTheme.blue.opacity(0.10))
                                .clipShape(Capsule())

                            Spacer()
                        }

                        Text(item.title)
                            .font(.system(size: 28, weight: .black, design: .rounded))
                            .foregroundStyle(BridgeTheme.ink)
                            .lineSpacing(2)

                        HStack(spacing: 8) {
                            Text(visibleAuthor)
                            Text("·")
                            Text(item.viewCount == 0 ? "조회 -" : "조회 \(item.viewCount)")
                            Text("·")
                            Text("댓글 \(item.commentCount)")
                        }
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(BridgeTheme.muted)

                        Text(item.body)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(BridgeTheme.ink.opacity(0.82))
                            .lineSpacing(6)
                            .padding(16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(red: 0.97, green: 0.98, blue: 1.0))
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

                        HStack(spacing: 10) {
                            DetailActionButton(title: "저장", systemName: "bookmark.fill")
                            DetailActionButton(title: "공유", systemName: "square.and.arrow.up")
                            DetailActionButton(title: "신고", systemName: "exclamationmark.triangle.fill")
                        }

                    }
                    .padding(18)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .shadow(color: .black.opacity(0.04), radius: 12, x: 0, y: 6)

                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("댓글")
                                .font(.system(size: 22, weight: .black, design: .rounded))
                                .foregroundStyle(BridgeTheme.ink)

                            Spacer()

                            Text("익명 댓글 가능")
                                .font(.system(size: 12, weight: .black))
                                .foregroundStyle(BridgeTheme.muted)
                        }

                        ForEach(sampleComments) { comment in
                            CommentRow(comment: comment)
                        }

                        VStack(alignment: .leading, spacing: 12) {
                            Text("댓글을 입력하세요.")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(BridgeTheme.muted)

                            HStack {
                                Text("익명 댓글 ON")
                                    .font(.system(size: 12, weight: .black))
                                    .foregroundStyle(BridgeTheme.blue)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 7)
                                    .background(BridgeTheme.blue.opacity(0.08))
                                    .clipShape(Capsule())

                                Spacer()

                                Text("댓글 등록")
                                    .font(.system(size: 13, weight: .black))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 9)
                                    .background(BridgeTheme.blue)
                                    .clipShape(Capsule())
                            }
                        }
                        .padding(14)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(Color.black.opacity(0.06), lineWidth: 1)
                        )
                    }
                    .padding(18)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                }
                .padding(18)
            }
        }
        .navigationTitle("게시글")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailActionButton: View {
    let title: String
    let systemName: String

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: systemName)
                .font(.system(size: 12, weight: .black))

            Text(title)
                .font(.system(size: 12, weight: .black))
        }
        .foregroundStyle(BridgeTheme.muted)
        .padding(.horizontal, 12)
        .padding(.vertical, 9)
        .background(Color(red: 0.96, green: 0.97, blue: 0.99))
        .clipShape(Capsule())
    }
}

struct PostComment: Identifiable {
    let id: String
    let authorId: String
    let displayName: String
    let isAnonymous: Bool
    let body: String
    let likeCount: Int
    let createdText: String
}

struct CommentRow: View {
    let comment: PostComment

    private var visibleAuthor: String {
        comment.isAnonymous ? "익명" : comment.displayName
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Text(String(visibleAuthor.prefix(1)))
                    .font(.system(size: 12, weight: .black))
                    .foregroundStyle(BridgeTheme.blue)
                    .frame(width: 28, height: 28)
                    .background(BridgeTheme.blue.opacity(0.12))
                    .clipShape(Circle())

                Text(visibleAuthor)
                    .font(.system(size: 13, weight: .black))
                    .foregroundStyle(BridgeTheme.ink)

                Text("· \(comment.createdText)")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(BridgeTheme.muted)

                Spacer()

                Image(systemName: "heart")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(BridgeTheme.muted)

                Text("\(comment.likeCount)")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(BridgeTheme.muted)
            }

            Text(comment.body)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(BridgeTheme.ink.opacity(0.82))
                .lineSpacing(4)
                .padding(.leading, 36)

        }
        .padding(.vertical, 10)
    }
}

struct HeroStat: View {

    let number: String

    let label: String

    var body: some View {

        VStack(spacing: 4) {

            Text(number)

                .font(.system(size: 18, weight: .black, design: .rounded))

                .foregroundStyle(.white)

            Text(label)

                .font(.system(size: 10, weight: .bold))

                .foregroundStyle(.white.opacity(0.75))

        }

        .frame(maxWidth: .infinity)

        .padding(.vertical, 12)

        .background(.white.opacity(0.12))

        .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))

    }

}

struct BoardCategoryCard: View {

    private let categories = [("전체", "112"), ("자유", "42"), ("비밀", "18"), ("정보", "31"), ("룸메이트", "14"), ("인턴십", "7")]

    var body: some View {

        VStack(alignment: .leading, spacing: 12) {

            HStack {
                Text("게시판")
                    .font(.system(size: 15, weight: .black))
                Spacer()
                Text("학교별 커뮤니티")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(BridgeTheme.muted)
            }

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {

                ForEach(categories, id: \.0) { item in

                    HStack {

                        Text(item.0)

                            .font(.system(size: 13, weight: .black))

                        Spacer()

                        Text(item.1)

                            .font(.system(size: 12, weight: .bold))

                    }

                    .foregroundStyle(item.0 == "전체" ? .white : BridgeTheme.muted)

                    .padding(.horizontal, 13)

                    .padding(.vertical, 11)

                    .background(item.0 == "전체" ? BridgeTheme.blue : Color(red: 0.97, green: 0.98, blue: 1.0))

                    .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))

                }

            }

        }

        .padding(16)

        .background(.white)

        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

    }

}

struct SearchBarView: View {

    let placeholder: String

    var body: some View {

        HStack(spacing: 10) {

            Image(systemName: "magnifyingglass")

                .foregroundStyle(BridgeTheme.muted)

            Text(placeholder)

                .font(.system(size: 13, weight: .semibold))

                .foregroundStyle(BridgeTheme.muted.opacity(0.75))

            Spacer()

        }

        .padding(15)

        .background(.white)

        .clipShape(RoundedRectangle(cornerRadius: 17, style: .continuous))

    }

}

struct PopularPostsCard: View {

    let posts: [BoardPost]

    var body: some View {

        VStack(alignment: .leading, spacing: 12) {

            HStack {

                VStack(alignment: .leading, spacing: 3) {

                    Text("인기 게시판")

                        .font(.system(size: 12, weight: .black))

                        .foregroundStyle(BridgeTheme.blue)

                    Text("지금 많이 보는 글")

                        .font(.system(size: 22, weight: .black, design: .rounded))

                }

                Spacer()

                Text("새 글 쓰기")

                    .font(.system(size: 12, weight: .black))

                    .foregroundStyle(BridgeTheme.blue)

                    .padding(.horizontal, 12)

                    .padding(.vertical, 8)

                    .background(BridgeTheme.blue.opacity(0.08))

                    .clipShape(Capsule())

            }

            ForEach(posts.prefix(4)) { post in

                PostRow(post: post)

            }

        }

        .padding(18)

        .background(.white)

        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))

    }

}

struct LatestPostsCard: View {

    let posts: [BoardPost]

    var body: some View {

        VStack(alignment: .leading, spacing: 12) {

            HStack {

                Text("최신 게시글")

                    .font(.system(size: 22, weight: .black, design: .rounded))

                Spacer()

                Text("방금 업데이트")

                    .font(.system(size: 12, weight: .bold))

                    .foregroundStyle(BridgeTheme.muted)

            }

            ForEach(posts) { post in

                CompactPostRow(post: post)

            }

        }

        .padding(18)

        .background(.white)

        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))

    }

}

struct PostRow: View {

    let post: BoardPost

    var body: some View {

        VStack(alignment: .leading, spacing: 8) {

            HStack {

                Text(post.category)

                    .font(.system(size: 11, weight: .black))

                    .foregroundStyle(BridgeTheme.blue)

                    .padding(.horizontal, 9)

                    .padding(.vertical, 5)

                    .background(BridgeTheme.blue.opacity(0.08))

                    .clipShape(Capsule())

                Spacer()

                Text("방금 전")

                    .font(.system(size: 11, weight: .bold))

                    .foregroundStyle(BridgeTheme.muted)

            }

            Text(post.title)

                .font(.system(size: 17, weight: .black, design: .rounded))

                .foregroundStyle(BridgeTheme.ink)

            Text(post.detail)

                .font(.system(size: 13, weight: .semibold))

                .foregroundStyle(BridgeTheme.muted)

                .lineLimit(2)

            Text("댓글 \(post.comments)   저장 3   익명")

                .font(.system(size: 11, weight: .bold))

                .foregroundStyle(BridgeTheme.muted)

        }

        .padding(15)

        .background(Color(red: 0.97, green: 0.98, blue: 1.0))

        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

    }

}

struct CompactPostRow: View {

    let post: BoardPost

    var body: some View {

        HStack {

            VStack(alignment: .leading, spacing: 5) {

                Text(post.category)

                    .font(.system(size: 11, weight: .black))

                    .foregroundStyle(BridgeTheme.blue)

                Text(post.title)

                    .font(.system(size: 15, weight: .black))

                    .foregroundStyle(BridgeTheme.ink)

            }

            Spacer()

            Text("댓글 \(post.comments)")

                .font(.system(size: 12, weight: .bold))

                .foregroundStyle(BridgeTheme.muted)

        }

        .padding(14)

        .background(Color(red: 0.97, green: 0.98, blue: 1.0))

        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))

    }

}

struct ScheduleScreen: View {

    @Binding var selectedSemester: String

    let courses: [Course]

    let uniqueCourses: [Course]

    let nextCourse: Course?

    let semesters: [String]

    let days: [String]

    let dayLabels: [String: String]

    let hours: [Int]

    let onAdd: () -> Void

    let onEdit: (Course) -> Void

    var body: some View {

        NavigationStack {

            ZStack {

                BridgeTheme.background.ignoresSafeArea()

                ScrollView {

                    VStack(spacing: 16) {

                        HStack {

                            VStack(alignment: .leading, spacing: 4) {

                                Text("2026년 1학기")

                                    .font(.system(size: 12, weight: .bold))

                                    .foregroundStyle(Color.red)

                                Text("시간표")

                                    .font(.system(size: 30, weight: .black, design: .rounded))

                            }

                            Spacer()

                            IconButton(systemName: "plus", action: onAdd)

                            IconButton(systemName: "gearshape.fill", action: { if let first = courses.first { onEdit(first) } })

                        }

                        VStack(alignment: .leading, spacing: 12) {

                            Picker("Semester", selection: $selectedSemester) {

                                ForEach(semesters, id: \.self) { semester in

                                    Text(semester).tag(semester)

                                }

                            }

                            .pickerStyle(.menu)

                            .tint(BridgeTheme.blue)

                            WeeklyTimetableView(courses: courses, days: days, dayLabels: dayLabels, hours: hours, onTapCourse: onEdit)

                        }

                        .padding(14)

                        .background(.white)

                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))

                        .shadow(color: .black.opacity(0.05), radius: 16, x: 0, y: 8)

                        NextClassCard(course: nextCourse)

                        MyClassListCard(courses: uniqueCourses, onEdit: onEdit)

                    }

                    .padding(.horizontal, 18)

                    .padding(.top, 14)

                    .padding(.bottom, 28)

                }

            }

            .navigationBarHidden(true)

        }

    }

}

struct IconButton: View {

    let systemName: String

    let action: () -> Void

    var body: some View {

        Button(action: action) {

            Image(systemName: systemName)

                .font(.system(size: 16, weight: .black))

                .foregroundStyle(systemName == "plus" ? BridgeTheme.blue : BridgeTheme.muted)

                .frame(width: 38, height: 38)

                .background(.white)

                .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))

        }

    }

}

struct NextClassCard: View {

    let course: Course?

    var body: some View {

        VStack(alignment: .leading, spacing: 12) {

            Text("오늘의 수업")

                .font(.system(size: 15, weight: .black))

                .foregroundStyle(BridgeTheme.blue)

            if let course {

                Text(course.code)

                    .font(.system(size: 26, weight: .black, design: .rounded))

                Text("\(course.timeText) · \(course.building) · Room \(course.room)")

                    .font(.system(size: 14, weight: .bold))

                    .foregroundStyle(BridgeTheme.muted)

                Text("다음 수업까지 1시간 20분 남았어요.")

                    .font(.system(size: 14, weight: .black))

                    .foregroundStyle(BridgeTheme.blue)

                    .padding(.horizontal, 14)

                    .padding(.vertical, 12)

                    .frame(maxWidth: .infinity, alignment: .leading)

                    .background(BridgeTheme.blue.opacity(0.08))

                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))

            }

        }

        .padding(18)

        .frame(maxWidth: .infinity, alignment: .leading)

        .background(.white)

        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))

    }

}

struct MyClassListCard: View {

    let courses: [Course]

    let onEdit: (Course) -> Void

    var body: some View {

        VStack(alignment: .leading, spacing: 12) {

            Text("내 수업")

                .font(.system(size: 15, weight: .black))

                .foregroundStyle(BridgeTheme.blue)

            ForEach(courses) { course in

                Button { onEdit(course) } label: {

                    HStack {

                        VStack(alignment: .leading, spacing: 4) {

                            Text(course.code)

                                .font(.system(size: 16, weight: .black, design: .rounded))

                                .foregroundStyle(BridgeTheme.ink)

                            Text(course.name)

                                .font(.system(size: 13, weight: .bold))

                                .foregroundStyle(BridgeTheme.muted)

                            Text("\(course.building) · Room \(course.room)")

                                .font(.system(size: 12, weight: .bold))

                                .foregroundStyle(BridgeTheme.muted)

                        }

                        Spacer()

                        Text("3학점")

                            .font(.system(size: 12, weight: .black))

                            .foregroundStyle(BridgeTheme.muted)

                    }

                    .padding(14)

                    .background(Color(red: 0.97, green: 0.98, blue: 1.0))

                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                }

                .buttonStyle(.plain)

            }

        }

        .padding(18)

        .background(.white)

        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))

    }

}

struct CourseRoomScreen: View {

    let courses: [Course]

    var body: some View {

        ZStack {

            BridgeTheme.background.ignoresSafeArea()

            ScrollView {

                VStack(alignment: .leading, spacing: 16) {

                    HStack {

                        Text("강의실")

                            .font(.system(size: 30, weight: .black, design: .rounded))

                        Spacer()

                        Image(systemName: "xmark")

                            .font(.system(size: 16, weight: .bold))

                            .foregroundStyle(BridgeTheme.muted)

                    }

                    SearchBarView(placeholder: "과목명, 교수명으로 검색")

                    ForEach(courses) { course in

                        VStack(alignment: .leading, spacing: 8) {

                            HStack {

                                Text(course.code)

                                    .font(.system(size: 18, weight: .black, design: .rounded))

                                Spacer()

                                Text("23년 2학기 수강자")

                                    .font(.system(size: 12, weight: .bold))

                                    .foregroundStyle(BridgeTheme.muted)

                            }

                            Text("★ ★ ★ ★ ☆")

                                .font(.system(size: 12, weight: .black))

                                .foregroundStyle(Color.yellow)

                            Text("\(course.name) · \(course.professor)")

                                .font(.system(size: 14, weight: .bold))

                                .foregroundStyle(BridgeTheme.muted)

                            Text("\(course.building) · Room \(course.room)")

                                .font(.system(size: 14, weight: .black))

                                .foregroundStyle(BridgeTheme.blue)

                            Text("유학생 메모: 첫 수업 전 건물 위치와 room number를 미리 확인하세요.")

                                .font(.system(size: 13, weight: .semibold))

                                .foregroundStyle(BridgeTheme.muted)

                        }

                        .padding(16)

                        .background(.white)

                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

                    }

                }

                .padding(22)

            }

        }

    }

}

struct GPAHelperScreen: View {

    var body: some View {

        ZStack {

            BridgeTheme.background.ignoresSafeArea()

            ScrollView {

                VStack(alignment: .leading, spacing: 16) {

                    Text("GPA 계산기")

                        .font(.system(size: 30, weight: .black, design: .rounded))

                    FeatureCard(title: "학점 예상", detail: "A, AB, B, BC, C 기준으로 예상 GPA를 계산해요.", icon: "chart.bar.fill")

                    FeatureCard(title: "편입 목표", detail: "목표 GPA에 맞춰 이번 학기 필요한 성적을 확인해요.", icon: "target")

                    FeatureCard(title: "유학생 메모", detail: "성적표, credit, drop deadline 용어를 쉽게 정리해요.", icon: "book.fill")

                }

                .padding(22)

            }

        }

    }

}

struct CampusHelperScreen: View {

    var body: some View {

        ZStack {

            BridgeTheme.background.ignoresSafeArea()

            ScrollView {

                VStack(alignment: .leading, spacing: 16) {

                    Text("캠퍼스소식")

                        .font(.system(size: 30, weight: .black, design: .rounded))

                    FeatureCard(title: "유학생 학기 시작 체크리스트", detail: "I-20, 수강신청, UHS, 은행, SSN까지 한 번에 정리", icon: "checklist")

                    FeatureCard(title: "오늘의 캠퍼스 영어", detail: "교수님께 보내는 메일, office hour 질문 표현", icon: "text.bubble")

                    FeatureCard(title: "학교 인증", detail: ".edu 이메일 인증으로 같은 학교 커뮤니티에 참여", icon: "checkmark.seal.fill")

                }

                .padding(22)

            }

        }

    }

}

struct FeatureCard: View {

    let title: String

    let detail: String

    let icon: String

    var body: some View {

        HStack(spacing: 14) {

            Image(systemName: icon)

                .font(.system(size: 19, weight: .black))

                .foregroundStyle(BridgeTheme.blue)

                .frame(width: 44, height: 44)

                .background(BridgeTheme.blue.opacity(0.10))

                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

            VStack(alignment: .leading, spacing: 5) {

                Text(title)

                    .font(.system(size: 16, weight: .black, design: .rounded))

                    .foregroundStyle(BridgeTheme.ink)

                Text(detail)

                    .font(.system(size: 13, weight: .semibold))

                    .foregroundStyle(BridgeTheme.muted)

            }

            Spacer()

        }

        .padding(16)

        .background(.white)

        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

    }

}

struct WeeklyTimetableView: View {

    let courses: [Course]

    let days: [String]

    let dayLabels: [String: String]

    let hours: [Int]

    let onTapCourse: (Course) -> Void

    private let timeColumnWidth: CGFloat = 38

    private let hourHeight: CGFloat = 68

    private let headerHeight: CGFloat = 32

    private let dayColumnWidth: CGFloat = 96

    var body: some View {

        ScrollView(.horizontal, showsIndicators: false) {

            VStack(spacing: 0) {

                HStack(spacing: 0) {

                    Color.clear.frame(width: timeColumnWidth, height: headerHeight)

                    ForEach(days, id: \.self) { day in

                        Text(dayLabels[day] ?? day)

                            .font(.system(size: 13, weight: .black))

                            .foregroundStyle(BridgeTheme.muted)

                            .frame(width: dayColumnWidth, height: headerHeight)

                    }

                }

                ZStack(alignment: .topLeading) {

                    timetableGrid

                    ForEach(courses) { course in

                        CourseBlock(course: course)

                            .frame(width: dayColumnWidth - 8, height: blockHeight(for: course))

                            .offset(x: xOffset(for: course), y: yOffset(for: course))

                            .onTapGesture { onTapCourse(course) }

                    }

                }

                .frame(width: timeColumnWidth + dayColumnWidth * CGFloat(days.count), height: hourHeight * CGFloat(hours.count))

                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(Color(red: 0.88, green: 0.91, blue: 0.95), lineWidth: 1))

            }

        }

    }

    private var timetableGrid: some View {

        VStack(spacing: 0) {

            ForEach(hours, id: \.self) { hour in

                HStack(spacing: 0) {

                    Text(displayHour(hour))

                        .font(.system(size: 12, weight: .bold))

                        .foregroundStyle(BridgeTheme.muted)

                        .frame(width: timeColumnWidth, height: hourHeight, alignment: .topTrailing)

                        .padding(.trailing, 7)

                        .padding(.top, 7)

                    ForEach(days, id: \.self) { _ in

                        Rectangle()

                            .fill(.white)

                            .frame(width: dayColumnWidth, height: hourHeight)

                            .border(Color(red: 0.90, green: 0.92, blue: 0.96), width: 0.5)

                    }

                }

            }

        }

    }

    private func xOffset(for course: Course) -> CGFloat {

        let index = days.firstIndex(of: course.day) ?? 0

        return timeColumnWidth + CGFloat(index) * dayColumnWidth + 4

    }

    private func yOffset(for course: Course) -> CGFloat {

        let start = (course.startHour - (hours.first ?? 9)) * 60

        return CGFloat(start) / 60 * hourHeight + 3

    }

    private func blockHeight(for course: Course) -> CGFloat {

        let duration = (course.endHour - course.startHour) * 60

        return max(CGFloat(duration) / 60 * hourHeight - 6, 42)

    }

    private func displayHour(_ hour: Int) -> String {

        if hour == 12 { return "12" }

        return hour > 12 ? "\(hour - 12)" : "\(hour)"

    }

}

struct CourseBlock: View {

    let course: Course

    var body: some View {

        VStack(alignment: .leading, spacing: 4) {

            Text(course.code)

                .font(.system(size: 12, weight: .black, design: .rounded))

                .foregroundStyle(BridgeTheme.ink)

                .lineLimit(2)

            Text("\(course.building) · \(course.room)")

                .font(.system(size: 10, weight: .black))

                .foregroundStyle(BridgeTheme.muted)

                .lineLimit(2)

        }

        .padding(8)

        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

        .background(course.color)

        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

    }

}

struct WritePostView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var selectedCategory = "비밀"

    @State private var isAnonymous = true

    @State private var title = ""

    @State private var bodyText = ""

    private let categories = ["자유", "비밀", "정보", "룸메이트", "인턴십"]

    var body: some View {

        NavigationStack {

            ZStack {

                BridgeTheme.background.ignoresSafeArea()

                ScrollView {

                    VStack(alignment: .leading, spacing: 18) {

                        BoardHeroForWrite()

                        VStack(alignment: .leading, spacing: 16) {

                            Text("게시판 선택")
                                .font(.system(size: 15, weight: .black))

                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                                ForEach(categories, id: \.self) { category in
                                    Button {
                                        selectedCategory = category
                                    } label: {
                                        Text(category)
                                            .font(.system(size: 14, weight: .black))
                                            .foregroundStyle(selectedCategory == category ? .white : BridgeTheme.ink)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 13)
                                            .background(selectedCategory == category ? BridgeTheme.blue : .white)
                                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                                    .stroke(Color.black.opacity(0.06), lineWidth: 1)
                                            )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }

                            Text("작성 방식")

                                .font(.system(size: 15, weight: .black))

                            HStack(spacing: 10) {

                                ToggleButton(title: "익명", detail: "이름을 숨기고 편하게 질문해요.", selected: isAnonymous) { isAnonymous = true }

                                ToggleButton(title: "닉네임", detail: "내 닉네임으로 소통해요.", selected: !isAnonymous) { isAnonymous = false }

                            }

                            LabeledInput(title: "제목", placeholder: "제목을 입력하세요", text: $title)

                            VStack(alignment: .leading, spacing: 8) {

                                Text("내용")

                                    .font(.system(size: 14, weight: .black))

                                TextEditor(text: $bodyText)

                                    .frame(height: 220)

                                    .padding(10)

                                    .background(.white)

                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.black.opacity(0.08), lineWidth: 1))

                            }

                            Button { dismiss() } label: {

                                Text("등록하기")

                                    .font(.system(size: 16, weight: .black))

                                    .foregroundStyle(.white)

                                    .frame(maxWidth: .infinity)

                                    .padding(.vertical, 15)

                                    .background(BridgeTheme.blue)

                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                            }

                        }

                        .padding(18)

                        .background(.white)

                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))

                    }

                    .padding(20)

                }

            }

            .toolbar {

                ToolbarItem(placement: .topBarTrailing) {

                    Button("취소") { dismiss() }

                }

            }

        }

    }

}

struct BoardHeroForWrite: View {

    var body: some View {

        VStack(alignment: .leading, spacing: 12) {

            Text("Campus Community")

                .font(.system(size: 12, weight: .black))

                .foregroundStyle(.white.opacity(0.85))

                .padding(.horizontal, 12)

                .padding(.vertical, 8)

                .background(.white.opacity(0.12))

                .clipShape(Capsule())

            Text("새 글 쓰기")

                .font(.system(size: 35, weight: .black, design: .rounded))

                .foregroundStyle(.white)

            Text("익명 또는 닉네임으로 게시할 수 있어요. 공적인 정보부터 사적인 고민까지 부담 없이 남겨보세요.")

                .font(.system(size: 15, weight: .semibold))

                .foregroundStyle(.white.opacity(0.85))

        }

        .padding(24)

        .frame(maxWidth: .infinity, alignment: .leading)

        .background(BridgeTheme.blue)

        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))

    }

}

struct ToggleButton: View {

    let title: String

    let detail: String

    let selected: Bool

    let action: () -> Void

    var body: some View {

        Button(action: action) {

            VStack(alignment: .leading, spacing: 6) {

                Text(title)
                    .font(.system(size: 15, weight: .black))

                Text(detail)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(selected ? BridgeTheme.blue : BridgeTheme.muted)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)

            }

            .foregroundStyle(selected ? BridgeTheme.blue : BridgeTheme.ink)

            .padding(13)

            .frame(maxWidth: .infinity, minHeight: 92, alignment: .topLeading)

            .background(selected ? BridgeTheme.blue.opacity(0.07) : Color(red: 0.97, green: 0.98, blue: 1.0))

            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            .overlay(RoundedRectangle(cornerRadius: 16).stroke(selected ? BridgeTheme.blue : Color.black.opacity(0.07), lineWidth: 1))

        }

    }

}

struct LabeledInput: View {

    let title: String

    let placeholder: String

    @Binding var text: String

    var body: some View {

        VStack(alignment: .leading, spacing: 8) {

            Text(title)

                .font(.system(size: 14, weight: .black))

            TextField(placeholder, text: $text)

                .padding(15)

                .background(.white)

                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.black.opacity(0.08), lineWidth: 1))

        }

    }

}

struct CourseFormView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var course: Course

    let onSave: (Course) -> Void

    private let days = ["Mon", "Tue", "Wed", "Thu", "Fri"]

    private let colors = [

        Color(red: 0.80, green: 0.89, blue: 1.0),

        Color(red: 0.88, green: 0.85, blue: 1.0),

        Color(red: 0.82, green: 0.95, blue: 0.86),

        Color(red: 1.0, green: 0.92, blue: 0.65),

        Color(red: 1.0, green: 0.80, blue: 0.84)

    ]

    init(course: Course? = nil, onSave: @escaping (Course) -> Void) {

        _course = State(initialValue: course ?? Course(code: "", name: "", day: "Mon", startHour: 9, endHour: 10, building: "", room: "", professor: "", color: Color(red: 0.80, green: 0.89, blue: 1.0)))

        self.onSave = onSave

    }

    var body: some View {

        NavigationStack {

            Form {

                Section("Class") {

                    TextField("Course code, ex. CS 300", text: $course.code)

                    TextField("Course name", text: $course.name)

                    TextField("Professor", text: $course.professor)

                }

                Section("Time") {

                    Picker("Day", selection: $course.day) {

                        ForEach(days, id: \.self) { day in Text(day).tag(day) }

                    }

                    Stepper("Start: \(course.startHour):00", value: $course.startHour, in: 7...22)

                    Stepper("End: \(course.endHour):00", value: $course.endHour, in: 8...23)

                }

                Section("Location") {

                    TextField("Building", text: $course.building)

                    TextField("Room", text: $course.room)

                }

                Section("Color") {

                    HStack(spacing: 12) {

                        ForEach(colors, id: \.self) { color in

                            Circle()

                                .fill(color)

                                .frame(width: 34, height: 34)

                                .overlay(Circle().stroke(course.color == color ? Color.primary : Color.clear, lineWidth: 3))

                                .onTapGesture { course.color = color }

                        }

                    }

                    .padding(.vertical, 6)

                }

            }

            .navigationTitle(course.code.isEmpty ? "Add Course" : "Edit Course")

            .navigationBarTitleDisplayMode(.inline)

            .toolbar {

                ToolbarItem(placement: .topBarLeading) { Button("Cancel") { dismiss() } }

                ToolbarItem(placement: .topBarTrailing) {

                    Button("Save") {

                        onSave(course)

                        dismiss()

                    }

                    .fontWeight(.bold)

                    .disabled(course.code.trimmingCharacters(in: .whitespaces).isEmpty)

                }

            }

        }

    }

}

#Preview {

    ContentView()

}
