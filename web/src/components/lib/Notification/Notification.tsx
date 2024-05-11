import React, { useEffect, useState, useCallback } from 'react'
import './Notification.scss'

interface NotificationProps {
    message: string | null
    onEnd: () => void
    timeout?: number
}

const Notification: React.FC<NotificationProps> = ({ message, onEnd, timeout = 3000 }) => {
    const [visible, setVisible] = useState(false)

    useEffect(() => {
        if (message) {
            setVisible(true)
            setTimeout(() => {
                setVisible(false)
                setTimeout(onEnd, 500) // Ожидаем завершения анимации
            }, timeout)
        }
    }, [message, onEnd, timeout])

    const notificationClass = visible ? 'show' : 'hide'

    return message ? (
        <div className={`notification-alert ${notificationClass}`}>
            {message}
        </div>
    ) : null
}

export default Notification
