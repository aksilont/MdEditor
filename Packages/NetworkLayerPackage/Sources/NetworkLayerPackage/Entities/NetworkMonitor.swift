//
//  NetworkMonitor.swift
//  NetworkLayer
//
//  Created by Kirill Leonov 
//

import Foundation
import Network

/// Мониторинг сетевого подключения.
public protocol INetworkMonitor {
	/// Свойство, показывающий наличие сетевого подключения.
	var isConnected: Bool { get }
	/// Тип сетевого подключения.
	var connectionType: ConnectionType { get }
	
	/// Запуск мониторинга сети.
	func start()
	/// Остановка мониторинга сети.
	func stop()
}

/// Тип сетевого подключения.
public enum ConnectionType {
	/// Подключение по беспроводному интерфейсу.
	case wifi
	/// Подключение через сотовую сеть.
	case cellular
	/// Подключение по проводному интерфейсу.
	case ethernet
	/// Неизвестный источник подключения или отсутствие подключения.
	case unknown
	
	init(_ path: NWPath) {
		if path.usesInterfaceType(.wifi) {
			self = .wifi
		} else if path.usesInterfaceType(.cellular) {
			self = .cellular
		} else if path.usesInterfaceType(.wiredEthernet) {
			self = .ethernet
		} else {
			self = .unknown
		}
	}
}

/// Мониторинг сетевого подключения. Выполнен в виде Singleton, рекомендуется передавать только как зависимость.
public final class NetworkMonitor: INetworkMonitor {
	// MARK: - Public properties
	
	/// Инстанс мониторинга сети.
	static let shared = NetworkMonitor()
	
	/// Свойство, показывающий наличие сетевого подключения.
	public private(set) var isConnected: Bool
	/// Тип сетевого подключения.
	public private(set) var connectionType: ConnectionType
			
	// MARK: - Dependencies
	private let queue = DispatchQueue.global()
	private let monitor: NWPathMonitor
	
	// MARK: - Initialization
	private init() {
		self.monitor = NWPathMonitor()
		self.isConnected = false
		self.connectionType = .unknown
	}
	
	// MARK: - Public methods
	
	/// Запуск мониторинга сети.
	public func start() {
		monitor.start(queue: queue)
		monitor.pathUpdateHandler = { [weak self] path in
			self?.isConnected = path.status != .unsatisfied
			self?.connectionType = ConnectionType(path)
		}
	}
	
	/// Остановка мониторинга сети.
	public func stop() {
		monitor.cancel()
	}
}
