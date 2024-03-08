import SwiftUI

struct ContentView: View {
    @State private var showingThresholdAlert = true
    @StateObject var paymentInfoDictionary = infoDictionary()
    @State var threshold: String = ""

    var body: some View {
        NavigationView {
            VStack {
                NaviView(pModel: paymentInfoDictionary)
                DisplayView(pModel: paymentInfoDictionary)
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Expense Tracking")
            .alert("Threshold", isPresented: $showingThresholdAlert, actions: {
                //gather threshold when started up
                TextField("Threshold in $", text: $threshold)
            })
        }
    }
}

struct NaviView: View {
    @ObservedObject var pModel: infoDictionary
    @State private var showingAddAlert = false
    @State private var navigateToAddPayment = false

    var body: some View {
        Text("")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        navigateToAddPayment = true
                    }) {
                        Image(systemName: "plus.app")
                    }
                }
            }
            .background(        //navigate to add payment
                NavigationLink(destination: AddPaymentView(pModel: pModel, path: $navigateToAddPayment), isActive: $navigateToAddPayment) {
                    EmptyView()
                }
            )
    }
}


struct AddPaymentView: View {
    @ObservedObject var pModel: infoDictionary
    @Binding var path: Bool
    @State private var isSavings = true

    var body: some View {
        VStack {
            //gather details about payment
            TextField("Description", text: $pModel.description)
                .padding()
            TextField("$ Amount", text: $pModel.amount)
                .padding()
            Toggle("Spendings... or ...Savings", isOn: $isSavings)
                .padding()
            DatePicker("Date/Time", selection: $pModel.time, in: ...Date(), displayedComponents: [.date, .hourAndMinute])
                .padding()

            HStack {
                Button("Add Payment") {
                    //save payment record
                    let category = isSavings ? "Savings" : "Spendings"
                    var amount = Double(pModel.amount) ?? 0.0
                    if category == "Spendings" {
                        amount *= -1
                    }
                    
                    pModel.add(pModel.description, "\(amount)", category, pModel.time)
                    //back to main page
                    path.toggle()
                }
                .padding()
            }
        }
        .navigationTitle("Add Payment")
    }
}

struct DisplayView: View {
    @ObservedObject var pModel: infoDictionary
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

    var body: some View {
        //display payment records
        VStack {
            List {
                ForEach(Array(pModel.infoRepository.keys), id: \.self) { key in
                    if let payment = pModel.infoRepository[key] {
                        VStack(alignment: .leading) {
                            Text("Description: \(payment.description ?? "")")
                            Text("Amount: \(payment.amount ?? "")")
                            Text("Category: \(payment.category ?? "")")
                            Text("Date/Time: \(formattedDate(payment.time))")
                        }
                    }
                }
            }
            //compare total to threshold
            Text("Total: \(String(format: "%.2f", pModel.total()))")
                .padding()
            let weeklyTotal = pModel.total()
            let threshold = 0.0
            if weeklyTotal < 0 && abs(weeklyTotal) < threshold {
                Text("You spent too much!")
            } else if weeklyTotal > 0 && weeklyTotal > threshold {
                Text("You saved some good money!")
            } else {
                Text("You have a normal budget now!")
            }
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
