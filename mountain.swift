import SwiftUI

struct mountain: View {
    @State private var todos: [String] = []

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Mountain Ranges")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)

                MountainRow(imageName: "skandigiri", name: "Skandigiri", location: "Bangalore", todos: $todos)
                MountainRow(imageName: "nandi", name: "Nandi Hills", location: "Bangalore", todos: $todos)
                MountainRow(imageName: "nanital", name: "Tiffin Top", location: "Nanital", todos: $todos)
                MountainRow(imageName: "chikmanglur", name: "Mullayanagiri", location: "Chikmangaluru", todos: $todos)
                MountainRow(imageName: "gulmarg", name: "Gulmarg", location: "Kashmir", todos: $todos)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Todo List")
                        .font(.headline)

                    ForEach(todos, id: \.self) { todo in
                        HStack {
                            Image(systemName: "checkmark.square")
                                .foregroundColor(.blue)

                            Text(todo)
                                .font(.subheadline)
                        }

                    }
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
            
        }
        .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.green.opacity(0.4), Color.white.opacity(0.3)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .edgesIgnoringSafeArea(.all)
                                    )
    }

    private func deleteTodo(at offsets: IndexSet) {
        todos.remove(atOffsets: offsets)
    }
}

struct MountainRow: View {
    let imageName: String
    let name: String
    let location: String
    @Binding var todos: [String]

    var body: some View {
        HStack(spacing: 10) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .cornerRadius(10)

            VStack(alignment: .leading, spacing: 5) {
                Text(name)
                    .font(.headline)

                Text(location)
                    .font(.subheadline)
                    .foregroundColor(.gray)

            }

            Button(action: {
                if todos.contains(name) {
                    todos.removeAll { $0 == name }
                } else {
                    todos.append(name)
                }
            }) {
                Image(systemName: todos.contains(name) ? "checkmark.square.fill" : "square")
                    .foregroundColor(.blue)
            }
        }
        .padding(.horizontal)
    }
}

struct MountainView_Previews: PreviewProvider {
    static var previews: some View {
        mountain()
    }
}

