import Foundation
import SwiftUI

@available(iOS 14.0, *)
public struct EightView: View {
    // @State private var isShowagenciessay: Bool = false
    public init(arrayData: [String: String], whenCompletePushToSeven: @escaping () -> Void, show: Binding<Bool>) {
        self.arrayData = arrayData
        self.whenCompletePushToSeven = whenCompletePushToSeven
        _show = show
    }

    @Binding var show: Bool
    @State var timeRemaining = 600 // 600
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Environment(\.scenePhase) var scenePhase
    @AppStorage("savedDate") var date: Date = Date()

    var whenCompletePushToSeven: () -> Void
    var arrayData: [String: String] = [:]
    public var body: some View {
        if show {
            GeometryReader { size in
                ZStack { Color.white
                    VStack(spacing: 10) {
                        HStack {
                            Image(packageResource: "imges_one", ofType: "png")
                                .resizable()
                                .frame(width: 40, height: 40, alignment: .center)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 3))

                            VStack(alignment: .leading, spacing: 4) {
                                Text(arrayData[ValueKey.nameapp.rawValue] ?? "").fontWeight(.bold)
                                Text(arrayData[ValueKey.titleapp.rawValue] ?? "")
                                    .font(.system(size: 13))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        } // HStack.
                        .padding(.bottom, 30)
                        .padding(.top, 20)
                        .padding(.horizontal, 5)

                        HStack(spacing: 5) {
                            Spacer()
                            ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .blue))
                            Text(arrayData[ValueKey.wereloading.rawValue] ?? "").fontWeight(.semibold)
                            Spacer()
                        }
                        Text(arrayData[ValueKey.timere.rawValue] ?? "").font(.system(size: 15))
                        Text(timeRemaining.secondsToHoursMinutesSeconds()).foregroundColor(Color.blue).fontWeight(.bold).font(.system(size: 35))
                            .onReceive(timer) { _ in
                                if timeRemaining > 0 {
                                    timeRemaining -= 1
                                }
                                if timeRemaining == 0 {
                                    self.show = false
                                    timeRemaining = 600
                                }
                            }
                        Text(arrayData[ValueKey.pleasedo.rawValue] ?? "").foregroundColor(Color.red).padding(.bottom, 20).opacity(0.8)
                    }
                }
                .cornerRadius(10)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 25)
                .padding(.vertical, size.size.height * 0.35)
            }
            .background(
                Color.black.opacity(0.45)
                    .edgesIgnoringSafeArea(.all)
            )
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    let interval = Date() - date
                    if let second = interval.second {
                        if second >= timeRemaining {
                            self.show = false
                            timeRemaining = 600
                            return
                        }
                        if second < timeRemaining {
                            timeRemaining -= second
                            return
                        }
                    }
                } else if newPhase == .inactive {
                } else if newPhase == .background {
                    date = Date()
                }
            }
        } else {
            Color.clear.onAppear {
                self.whenCompletePushToSeven()
            }
        }
    }
}

extension Int {
    func secondsToHoursMinutesSeconds() -> String {
        let minute = (self % 3600) / 60
        let second = (self % 3600) % 60
        if second == 0 {
            return String(minute) + ":" + "00"
        } else if second < 10 && second > 0 {
            return String(minute) + ":0" + String(second)
        } else {
            return String(minute) + ":" + String(second)
        }
    }
}

extension Date: RawRepresentable {
    private static let formatter = ISO8601DateFormatter()

    public var rawValue: String {
        Date.formatter.string(from: self)
    }

    public init?(rawValue: String) {
        self = Date.formatter.date(from: rawValue) ?? Date()
    }

    static func - (recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second

        return (month: month, day: day, hour: hour, minute: minute, second: second)
    }
}
