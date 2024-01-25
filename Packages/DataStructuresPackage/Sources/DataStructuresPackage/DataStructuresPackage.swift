import Foundation

/// Линейный двунаправленный список
public struct DoublyLinkedList<T> {

	/// Узел линейного двунаправленного списка
	public class Node {
		/// Значение, которое хранит узел
		public var value: T

		/// Ссылка на следующий узел, если он есть
		public var next: Node?

		/// Ссылка на предыдущий узел, если он есть
		public var previous: Node?

		/// Инициализатор узла линейного однонаправленного списка.
		/// - Parameters:
		///  - value: Значение для хранения в узле;
		///  - next:  Ссылка на следующий узел, если он есть;
		///  - previous:  Ссылка на предыдущий узел, если он есть.
		public init(_ value: T, previous: Node? = nil, next: Node? = nil) {
			self.value = value
			self.next = next
			self.previous = previous
		}
	}

	private var head: Node?
	private var tail: Node?

	/// Возвращает количество элементов списка.
	///
	/// Сложность O(1).

	private(set) var count: Int = 0

	/// Возвращает логическое значение, определяющее, пуст ли список.
	/// Сложность O(1).
	public var isEmpty: Bool {
		head == nil && tail == nil
	}

	/// Инициализатор списка.
	///  - Parameter value: Значение, которое будет добавлено в список.
	public init(value: T? = nil) {
		if let value = value {
			let newNode = Node(value)
			head = newNode
			tail = newNode
			count = 1
		}
	}

	/// Добавлeние в начало списка значения.
	///
	/// Сложность O(1).
	/// - Parameter value: Значение, которое будет добавлено в список.
	public mutating func push(_ value: T) {
		let newNode = Node(value, next: head)
		head?.previous = newNode
		head = newNode

		if tail == nil {
			tail = head
		}

		count += 1
	}

	/// Добавление в конец списка значения.
	///
	/// Сложность O(1).
	/// - Parameter value: Значение, которое будет добавлено в список.
	public mutating func append(_ value: T) {
		let newNode = Node(value, previous: tail)

		tail?.next = newNode
		tail = newNode

		if head == nil {
			head = tail
		}
		count += 1
	}

	/// Вставка в середину списка значения.
	///
	/// Сложность O(n).
	/// - Parameters:
	///  - value: Значение, которое будет вставлено в список.
	///  - index: Индекс, после которого будет вставлено значение.
	public mutating func insert(_ value: T, after index: Int) {
		guard let currentNode = node(at: index) else { return }
		let nextNode = currentNode.next
		let newNode = Node(value, previous: currentNode, next: nextNode)
		currentNode.next = newNode
		nextNode?.previous = newNode

		if newNode.next == nil {
			tail = newNode
		}

		count += 1
	}

	/// Извлечение значения из начала строки.
	///
	/// Сложность O(1).
	/// - Returns: Извлеченное из списка значение.
	public mutating func pop() -> T? {
		guard let currentHead = head else { return nil }
		head = currentHead.next
		head?.previous = nil
		if head == nil { tail = nil }

		count -= 1

		return currentHead.value
	}

	/// Извлечение значения из конца списка.
	///
	/// Сложность O(1).
	/// - Returns: Извлеченное из списка значение.
	public mutating func removeLast() -> T? {
		guard let currentTail = tail else { return nil }
		tail = currentTail.previous
		tail?.next = nil
		if tail == nil { head = nil }
		count -= 1

		return currentTail.value
	}

	/// Извлечение значения из середины списка.
	/// - Parameter index: Индекс, после которого надо извлечь значение.
	/// - Returns: Извлеченное из списка   значение.
	public mutating func remove(after index: Int) -> T? {
		guard let currentNode = node(at: index), let nextNode = currentNode.next else { return nil }
		if nextNode === tail {
			tail = currentNode
			currentNode.next = nil
		} else {
			currentNode.next = nextNode.next
			nextNode.next?.previous = currentNode
		}
		count -= 1
		return nextNode.value
	}

	/// Возвращает значение из списка без его изъятия.
	/// - Parameter index: Индекс, после которого надо извлечь значение.
	/// - Returns: Извлеченное из списка   значение.
	public func value(at index: Int) -> T? {
		node(at: index)?.value
	}

	private func node(at index: Int) -> Node? {
		guard index >= 0 && index < count else { return nil }
		var currentIndex = 0
		var currentNode: Node?
		if index <= count / 2 {
			currentNode = head
			while currentIndex < index {
				currentNode = currentNode?.next
				currentIndex += 1
			}
		} else {
			currentIndex = count - 1
			currentNode = tail
			while currentIndex > index {
				currentNode = currentNode?.previous
				currentIndex -= 1
			}
		}
		return currentNode
	}
}

extension DoublyLinkedList.Node: CustomStringConvertible {
	public var description: String {
		"\(value)"
	}
}

extension DoublyLinkedList: CustomStringConvertible {
	public var description: String {
		var values = [String]()
		var current = head

		while current != nil {
			values.append("\(current!)")
			current = current?.next
		}

		return "count = \(count); list = " + values.joined(separator: " <-> ")
	}
}

extension DoublyLinkedList {
	var headValue: T? {
		head?.value
	}

	var tailValue: T? {
		tail?.value
	}
}

/// Очередь на основе линейного двунаправленнго списка.
public struct Queue<T> {
	private var elements: DoublyLinkedList<T>

	/// Возвращает логическое значение, указывающее, пуста ли очередь.
	public var isEmpty: Bool {
		elements.isEmpty
	}

	/// Возвращает количество элементов в очереди.
	public var count: Int {
		elements.count
	}

	/// Возвращает первый элемент очереди.
	public var peek: T? {
		elements.value(at: 0)
	}

	///Инициализатор для очереди
	public init() {
		elements = DoublyLinkedList<T>()
	}

	/// Добавляет элемент в конец очереди.
	/// - Parameter element: элемент для добавления в очередь.
	public mutating func enqueue(_ value: T) {
		elements.append(value)
	}

	/// Удаляет и возвращает первый элемент очереди.
	/// - Returns: первый элемент очереди.
	public mutating func dequeue() -> T? {
		elements.pop()
	}
}
