import { configureStore } from '@reduxjs/toolkit'
import authSlice from './slices/authSlice'
import { TypedUseSelectorHook, useDispatch, useSelector } from 'react-redux'
import dataSlice from './slices/dataSlice'

export const store = configureStore({
    reducer: {
        auth: authSlice,
        data: dataSlice
    }
})

export type RootState = ReturnType<typeof store.getState>
export type AppDispatch = typeof store.dispatch

export const useAppDispatch: () => AppDispatch = useDispatch
export const useAppSelector: TypedUseSelectorHook<RootState> = useSelector