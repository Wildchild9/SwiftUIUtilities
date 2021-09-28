#if canImport(SwiftUI)
import SwiftUI

extension ForEach where Content : View {
    public init<D, T, U>(
        _ data: D,
        @ViewBuilder content: @escaping (D.Element) -> T,
        @ViewBuilder divider: @escaping (T) -> U
    ) where
        T: View,
        U: View,
        Content == SwiftUI._ConditionalContent<U, T>,
        D: RandomAccessCollection,
        ID == D.Element.ID,
        D.Element: Identifiable,
        Data == LazyMapSequence<D.Indices, (D.Index, ID)>
    {
        self.init(data.indices.lazy.map({ ($0, data[$0].id) }), id: \.1) { (index, _) in
            if data.startIndex != data.endIndex, index < data.index(before: data.endIndex) {
                divider(content(data[index]))
            } else {
                content(data[index])
            }
        }
    }
    
    public init<D, T, U>(
        _ data: D,
        id: KeyPath<D.Element, ID>,
        @ViewBuilder content: @escaping (D.Element) -> T,
        @ViewBuilder divider: @escaping (T) -> U
    ) where
        T: View,
        U: View,
        Content == SwiftUI._ConditionalContent<U, T>,
        D: RandomAccessCollection,
        Data == LazyMapSequence<D.Indices, (D.Index, ID)>
    {
        self.init(data.indices.lazy.map({ ($0, data[$0][keyPath: id]) }), id: \.1) { (index, _) in
            if data.startIndex != data.endIndex, index < data.index(before: data.endIndex) {
                divider(content(data[index]))
            } else {
                content(data[index])
            }
        }
    }

    
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension ForEach where Content: View {
    init<C, T, U>(
        _ data: Binding<C>,
        @ViewBuilder content: @escaping (Binding<C.Element>) -> T,
        @ViewBuilder divider: @escaping (T) -> U
    ) where
        T: View,
        U: View,
        Content == SwiftUI._ConditionalContent<U, T>,
        Data == LazyMapSequence<C.Indices, (C.Index, ID)>,
        ID == C.Element.ID,
        C: MutableCollection,
        C: RandomAccessCollection,
        C.Element : Identifiable,
        C.Index : Hashable
    {
        
        self.init(data.indices.lazy.map({ ($0, data[$0].id) }), id: \.1) { (index, _) in
            if data.startIndex != data.endIndex, index < data.index(before: data.endIndex) {
                divider(content(data[index].projectedValue))
            } else {
                content(data[index].projectedValue)
            }
        }
    }
    
    init<C, T, U>(
        _ data: Binding<C>,
        id: KeyPath<C.Element, ID>,
        content: @escaping (Binding<C.Element>) -> T,
        divider: @escaping (T) -> U
    ) where
        T: View,
        U: View,
        Content == SwiftUI._ConditionalContent<U, T>,
        Data == LazyMapSequence<C.Indices, (C.Index, ID)>,
        C: MutableCollection,
        C: RandomAccessCollection,
        C.Index : Hashable
    {
        self.init(data.indices.lazy.map({ ($0, data[$0].wrappedValue[keyPath: id]) }), id: \.1) { (index, _) in
            if data.startIndex != data.endIndex, index < data.index(before: data.endIndex) {
                divider(content(data[index].projectedValue))
            } else {
                content(data[index].projectedValue)
            }
        }
    }

}

extension ForEach where Data == Range<Int>, ID == Int, Content : View {

    public init<T, U>(
        _ data: Range<Int>,
        @ViewBuilder content: @escaping (Int) -> T,
        @ViewBuilder divider: @escaping (T) -> U
    ) where
        T: View,
        U: View,
        Content == SwiftUI._ConditionalContent<U, T>
    {
        self.init(data) { i in
            if i < data.endIndex - 1 {
                divider(content(i))
            } else {
                content(i)
            }
        }
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct Foo: View {
    
    var arr = [1, 2, 3, 4, 5]
    
    @State var strArr = ["a", "b", "c", "d"]
    public var body: some View {
        VStack {
            Text("Testing")
                .font(.title)
            Text(strArr.joined())
            Bar(arr: $strArr)
        }
        .padding()
//        VStack(spacing: 0) {
//            ForEach(arr) { i in
//                Text("\(i)")
//            } divider: { view in
//                view
//                    .background(
//                        Rectangle()
//                            .fill(Color.red)
//                    )
//                    .padding(.bottom, 10)
//            }
//        }
        
    }
}

extension String: Identifiable {
    public var id: String { return self }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct Bar: View {
    @Binding var arr: [String]
    
    public var body: some View {
        ForEach($arr, id: \.self) { str in
            TextField("text field", text: str)
        } divider: { view in
            VStack(spacing: 0) {
                view
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 0.5)
                    .padding(.vertical, 5)
            }
        }
    }
}
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct Foo_Previews: PreviewProvider {
    static var previews: some View {
        Foo()
    }
}

#endif
