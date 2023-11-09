import SwiftUI

struct AdventureActivity: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let imageName: String
}

struct adventure: View {
    let activities: [AdventureActivity] = [
        AdventureActivity(name: "Rock Climbing", description: "Scale the heights with safety gear.", imageName: "rock_climbing"),
        AdventureActivity(name: "River Rafting", description: "Paddle through the roaring rapids.", imageName: "river_rafting"),
        AdventureActivity(name: "Camping", description: "Sleep under the stars in the wilderness.", imageName: "accomodation"),
    ]
    
    @State private var todos: [String] = []
    @State private var newTodo = ""
    @State private var isAddingTodo = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(activities) { activity in
                            ActivityCard(activity: activity)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                Spacer()
                Text("Adventure To-do List")
                    .font(Font.system(size: 28))
                    .fontWeight(.bold)
                
                List {
                    ForEach(todos, id: \.self) { todo in
                        Text(todo)
                    }
                    .onDelete(perform: deleteTodo)
                }
                
                .listStyle(PlainListStyle())
                
                Button(action: {
                    isAddingTodo.toggle()
                }) {
                    Text("Add Todo")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .cornerRadius(25)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                }
                .sheet(isPresented: $isAddingTodo) {
                    TodoAddView(isAddingTodo: $isAddingTodo, todos: $todos, newTodo: $newTodo)
                }
            }
            .padding(.top, 20)
            .navigationBarTitle("Adventure Activities")
        }
    }
    
    private func deleteTodo(at offsets: IndexSet) {
        todos.remove(atOffsets: offsets)
    }
}

struct ActivityCard: View {
    let activity: AdventureActivity
    
    var body: some View {
        VStack {
            Image(activity.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .cornerRadius(20)
            
            Text(activity.name)
                .font(Font.system(size: 16))
        }
        .frame(width: 150, height: 200)
        .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue.opacity(0.4), Color.green.opacity(0.3)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .edgesIgnoringSafeArea(.all)
                                    )
        .cornerRadius(20)
    }
}

struct TodoAddView: View {
    @Binding var isAddingTodo: Bool
    @Binding var todos: [String]
    @Binding var newTodo: String
    
    var body: some View {
        VStack {
            TextField("Add a new todo", text: $newTodo)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)
            
            Button(action: {
                todos.append(newTodo)
                newTodo = ""
                isAddingTodo.toggle()
            }) {
                Text("Add")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .cornerRadius(25)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
            }
        }
        .padding()
    }
}

extension Color {
    static let primary = Color("PrimaryColor")
}

struct AdventureView_Previews: PreviewProvider {
    static var previews: some View {
        adventure()
    }
}

