#if canImport(SwiftUI)
import SwiftUI

//@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
//extension ForEach where ID == Data.Element.ID, Content : View, Data.Element : Identifiable {
//
//    /// Creates an instance that uniquely identifies and creates views across
//    /// updates based on the identity of the underlying data.
//    ///
//    /// It's important that the `id` of a data element doesn't change unless you
//    /// replace the data element with a new data element that has a new
//    /// identity. If the `id` of a data element changes, the content view
//    /// generated from that data element loses any current state and animations.
//    ///
//    /// - Parameters:
//    ///   - data: The identified data that the ``ForEach`` instance uses to
//    ///     create views dynamically.
//    ///   - content: The view builder that creates views dynamically.
//    public init<T, U>(_ data: Data, @ViewBuilder content: @escaping (Data.Element) -> T, @ViewBuilder divider: @escaping (T) -> U) where T: View, U: View, Content == SwiftUI._ConditionalContent<U, T> {
//
//        let canInsertDivider = data.count > 1
//        if canInsertDivider {
//            let lastId = data.last!.id
//            self.init(data) { element in
//                if lastId != element.id {
//                    divider(content(element))
//                } else {
//                    content(element)
//                }
//            }
//        } else {
//            self.init(data) { element in
//                // Used to match Content type
//                if false {
//                    divider(content(element))
//                } else {
//                    content(element)
//                }
//            }
//        }
//
//    }
//
//
////        let canInsertDivider = data.count > 1
////        if canInsertDivider {
////            let lastId = data.last!.id
////            self.init(data) { element in
////                if lastId != element.id {
////                    divider(content(element))
////                } else {
////                    content(element)
////                }
////            }
////        } else {
////            self.init(data) { element in
////                // Used to match Content type
////                if false {
////                    divider(content(element))
////                } else {
////                    content(element)
////                }
////            }
////        }
//
////        }
//}



@frozen
public struct EnumeratedRandomAccessCollection<Base: RandomAccessCollection> {
    @usableFromInline
    internal var _base: Base
    
    /// Construct from a `Base` sequence.
    @inlinable
    internal init(_base: Base) {
        self._base = _base
    }
}

extension EnumeratedRandomAccessCollection {
    /// The iterator for `EnumeratedRandomAccessCollection`.
    ///
    /// An instance of this iterator wraps a base iterator and yields
    /// successive `Int` values, starting at zero, along with the elements of the
    /// underlying base iterator. The following example enumerates the elements of
    /// an array:
    ///
    ///     var iterator = ["foo", "bar"].enumerated().makeIterator()
    ///     iterator.next() // (0, "foo")
    ///     iterator.next() // (1, "bar")
    ///     iterator.next() // nil
    ///
    /// To create an instance, call
    /// `enumerated().makeIterator()` on a random access collection.
    @frozen
    public struct Iterator {
        @usableFromInline
        internal var _baseIterator: Base.Iterator

        @usableFromInline
        internal var _index: Base.Index
        
        @usableFromInline
        internal var _advanceIndex: (inout Base.Index) -> Void
        
        /// Construct from a `Base` iterator.
        @inlinable
        internal init(_baseIterator: Base.Iterator, _baseStartIndex: Base.Index, _advanceIndex: @escaping (inout Base.Index) -> Void) {
            self._baseIterator = _baseIterator
            self._index = _baseStartIndex
            self._advanceIndex = _advanceIndex
        }
    }
}

extension EnumeratedRandomAccessCollection.Iterator: IteratorProtocol, Sequence {
    
    /// The type of element returned by `next()`.
    public typealias Element = (index: Base.Index, element: Base.Element)
    
    /// Advances to the next element and returns it, or `nil` if no next element
    /// exists.
    ///
    /// Once `nil` has been returned, all subsequent calls return `nil`.
    public dynamic mutating func next() -> Element? {
        guard let b = _baseIterator.next() else { return nil }
        let result = (index: _index, element: b)
        _advanceIndex(&_index)
        return result
    }
}

extension EnumeratedRandomAccessCollection: RandomAccessCollection {
    public var indices: Base.Indices {
        return _base.indices
    }
    
    public subscript(position: Self.Index) -> Self.Iterator.Element {
        return (index: position, element: _base[position])
    }
    
    public subscript(bounds: Range<Self.Index>) -> Self.SubSequence {
        return Self.SubSequence(base: self, bounds: bounds)
    }
    
    public func index(before i: Base.Index) -> Base.Index {
        return _base.index(before: i)
    }
    
    public func index(after i: Base.Index) -> Base.Index {
        return _base.index(after: i)
    }
    
    public var startIndex: Base.Index {
        return _base.startIndex
    }
    
    public var endIndex: Base.Index {
        return _base.endIndex
    }
    
    public typealias Index = Base.Index
    
    public typealias SubSequence = Slice<Self>
    
    public typealias Indices = Base.Indices
    
    /// Returns an iterator over the elements of this collection.
    public __consuming dynamic func makeIterator() -> Iterator {
        return Iterator(_baseIterator: _base.makeIterator(), _baseStartIndex: _base.startIndex) {
            _base.formIndex(after: &$0)
        }
    }
}

extension EnumeratedRandomAccessCollection: MutableCollection where Base: MutableCollection {
    public subscript(position: Base.Index) -> (index: Base.Index, element: Base.Element) {
        get {
            return (index: position, element: _base[position])
        }
        set {
            _base[position] = newValue.element
        }
    }
}


//extension RandomAccessCollection {
//    func enumerated() -> EnumeratedRandomAccessCollection<Self> {
//        return EnumeratedRandomAccessCollection(_base: self)
//    }
//}




extension ForEach where Content : View {
//    public init<D, T, U>(
//        _ data: D,
//        @ViewBuilder content: @escaping (D.Element) -> T,
//        @ViewBuilder divider: @escaping (T) -> U
//    ) where
//        T: View,
//        U: View,
//        Content == SwiftUI._ConditionalContent<U, T>,
//        D: RandomAccessCollection,
//        ID == D.Element.ID,
//        D.Element: Identifiable,
//        Data == EnumeratedRandomAccessCollection<D>
//    {
//        self.init(EnumeratedRandomAccessCollection(_base: data), id: \.element.id) { (index, element) in
//            if data.startIndex != data.endIndex, index < data.index(before: data.endIndex) {
//                divider(content(element))
//            } else {
//                content(element)
//            }
//        }
//    }
    
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
//    Data == EnumeratedRandomAccessCollection<Binding<C>>
    {
        
        self.init(data.indices.lazy.map({ ($0, data[$0].id) }), id: \.1) { (index, _) in
            if data.startIndex != data.endIndex, index < data.index(before: data.endIndex) {
                divider(content(data[index].projectedValue))
            } else {
                content(data[index].projectedValue)
            }
        }
//        self.init(EnumeratedRandomAccessCollection(_base: data), id: \.element.id) { (index, element) in
//            if data.startIndex != data.endIndex, index < data.index(before: data.endIndex) {
//                divider(content(element))
//            } else {
//                content(element)
//            }
//        }
    }
}


extension ForEach where Data == Range<Int>, ID == Int, Content : View {

    /// Creates an instance that computes views on demand over a given constant
    /// range.
    ///
    /// The instance only reads the initial value of the provided `data` and
    /// doesn't need to identify views across updates. To compute views on
    /// demand over a dynamic range, use ``ForEach/init(_:id:content:)``.
    ///
    /// - Parameters:
    ///   - data: A constant range.
    ///   - content: The view builder that creates views dynamically.
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

//extension ForEach {
//    init<C, T, U>(_ data: Binding<C>, @ViewBuilder content: @escaping (Binding<C.Element>) -> T, @ViewBuilder divider: @escaping (T) -> U) where Data == LazyMapSequence<C.Indices, (C.Index, ID)>, ID == C.Element.ID, C : MutableCollection, C : RandomAccessCollection, C.Element : Identifiable, C.Index : Hashable {
//
//    }
//}


//@available(macOS 10.15, *)
//extension ForEach {
//    init(_ data: Range<Int>, content: @escaping (Int) -> Content) {
//
//    }
//    init(Data, content: (Data.Element) -> Content) {
//
//    }
//    init<C>(Binding<C>, content: (Binding<C.Element>) -> Content) {
//
//    }
//    init(Data, id: KeyPath<Data.Element, ID>, content: (Data.Element) -> Content) {
//
//    }
//    init<C>(Binding<C>, id: KeyPath<C.Element, ID>, content: (Binding<C.Element>) -> Content) {
//
//    }
//    init(Data, content: (Data.Element) -> Content) {
//
//    }
//    init(Data, id: KeyPath<Data.Element, ID>, content: (Data.Element) -> Content) {
//
//    }
//    init<V>(Range<Int>, content: (Int) -> Content) {
//
//    }
//    init(Data, content: (Data.Element) -> Content) {
//
//    }
//    init<V>(Data, id: KeyPath<Data.Element, ID>, content: (Data.Element) -> Content) {
//
//    }
//
//
//
//}

extension Int: Identifiable {
    public var id: Int {
        return self
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
        ForEach($arr) { str in
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
