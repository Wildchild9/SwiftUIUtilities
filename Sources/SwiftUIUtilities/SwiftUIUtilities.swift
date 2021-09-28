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
    
    public init<D, T, U>(
        _ data: D,
        @ViewBuilder content: @escaping (D.Element) -> T,
        @ViewBuilder divider: @escaping () -> U
    ) where
        T: View,
        U: View,
        Content == SwiftUI._ConditionalContent<TupleView<(T, U)>, T>,
        D: RandomAccessCollection,
        ID == D.Element.ID,
        D.Element: Identifiable,
        Data == LazyMapSequence<D.Indices, (D.Index, ID)>
    {
        self.init(data.indices.lazy.map({ ($0, data[$0].id) }), id: \.1) { (index, _) in
            if data.startIndex != data.endIndex, index < data.index(before: data.endIndex) {
                content(data[index])
                divider()
            } else {
                content(data[index])
            }
        }
    }
    
    public init<D, T, U>(
        _ data: D,
        id: KeyPath<D.Element, ID>,
        @ViewBuilder content: @escaping (D.Element) -> T,
        @ViewBuilder divider: @escaping () -> U
    ) where
        T: View,
        U: View,
        Content == SwiftUI._ConditionalContent<TupleView<(T, U)>, T>,
        D: RandomAccessCollection,
        Data == LazyMapSequence<D.Indices, (D.Index, ID)>
    {
        self.init(data.indices.lazy.map({ ($0, data[$0][keyPath: id]) }), id: \.1) { (index, _) in
            if data.startIndex != data.endIndex, index < data.index(before: data.endIndex) {
                content(data[index])
                divider()
            } else {
                content(data[index])
            }
        }
    }
    
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension ForEach where Content: View {
    public init<C, T, U>(
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
    
    public init<C, T, U>(
        _ data: Binding<C>,
        id: KeyPath<C.Element, ID>,
        @ViewBuilder content: @escaping (Binding<C.Element>) -> T,
        @ViewBuilder divider: @escaping (T) -> U
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
    
    public init<C, T, U>(
        _ data: Binding<C>,
        @ViewBuilder content: @escaping (Binding<C.Element>) -> T,
        @ViewBuilder divider: @escaping () -> U
    ) where
        T: View,
        U: View,
        Content == SwiftUI._ConditionalContent<TupleView<(T, U)>, T>,
        Data == LazyMapSequence<C.Indices, (C.Index, ID)>,
        ID == C.Element.ID,
        C: MutableCollection,
        C: RandomAccessCollection,
        C.Element : Identifiable,
        C.Index : Hashable
    {
        
        self.init(data.indices.lazy.map({ ($0, data[$0].id) }), id: \.1) { (index, _) in
            if data.startIndex != data.endIndex, index < data.index(before: data.endIndex) {
                content(data[index].projectedValue)
                divider()
            } else {
                content(data[index].projectedValue)
            }
        }
    }
    
    public init<C, T, U>(
        _ data: Binding<C>,
        id: KeyPath<C.Element, ID>,
        @ViewBuilder content: @escaping (Binding<C.Element>) -> T,
        @ViewBuilder divider: @escaping () -> U
    ) where
        T: View,
        U: View,
        Content == SwiftUI._ConditionalContent<TupleView<(T, U)>, T>,
        Data == LazyMapSequence<C.Indices, (C.Index, ID)>,
        C: MutableCollection,
        C: RandomAccessCollection,
        C.Index : Hashable
    {
        self.init(data.indices.lazy.map({ ($0, data[$0].wrappedValue[keyPath: id]) }), id: \.1) { (index, _) in
            if data.startIndex != data.endIndex, index < data.index(before: data.endIndex) {
                content(data[index].projectedValue)
                divider()
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
    
    public init<T, U>(
        _ data: Range<Int>,
        @ViewBuilder content: @escaping (Int) -> T,
        @ViewBuilder divider: @escaping () -> U
    ) where
        T: View,
        U: View,
        Content == SwiftUI._ConditionalContent<TupleView<(T, U)>, T>
    {
        self.init(data) { i in
            if i < data.endIndex - 1 {
                content(i)
                divider()
            } else {
                content(i)
            }
        }
    }
}
#endif
