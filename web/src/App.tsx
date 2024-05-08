import React, { useEffect } from 'react'
import Login from './pages/Auth/Auth'
import News from './pages/News/WriteNews'
import NotFound from './pages/NotFound/NotFound'
import { createBrowserRouter, createRoutesFromElements, Route, RouterProvider, Navigate } from 'react-router-dom'
import './App.scss'
import { useAppDispatch, useAppSelector } from './store/store'
import { setIsLogin } from './store/slices/dataSlice'
import axios from 'axios'

const App: React.FC = () => {
    const data = useAppSelector(state => state.data)
    const dispatch = useAppDispatch()

    useEffect(() => {

    }, [])

    useEffect(() => {
        if (['false', null].includes(localStorage.getItem('isLogin'))) {
            dispatch(setIsLogin(false))
        } else {
            dispatch(setIsLogin(true))
            axios.defaults.headers['Authorization'] = localStorage.getItem('token')
        }
    }, [])

    const isNotlogin = (component: JSX.Element, elseUrl: string): JSX.Element => {
        if (data.isLogin) {
            return <Navigate to={elseUrl} />
        } else {
            return component
        }
    }

    const isLogin = (component: JSX.Element, elseUrl: string): JSX.Element => {
        if (data.isLogin) {
            return component
        } else {
            return <Navigate to={elseUrl} />
        }
    }

    const router = createBrowserRouter(
        createRoutesFromElements(
            <Route path='/'>
                <Route index element={<Navigate to='/login'/>}/>
                <Route path='/login' element={isNotlogin(<Login/>, '/news')} />
                <Route path='/news' element={isLogin(<News />, '/login')} />
                <Route path='*' element={<NotFound />} />
            </Route>
        )
    )

    return (
        <div className='app'>
            <RouterProvider router={router} />
        </div>
    )
}

export default App
