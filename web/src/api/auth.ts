import { createAsyncThunk } from '@reduxjs/toolkit'
import axios, { AxiosError } from 'axios'
import { setIsLogin } from '../store/slices/dataSlice'

interface LoginData {
    email: string
    password: string
}

type LoginResult = string

export const login = createAsyncThunk('auth/login', async (data: LoginData, thunkAPI) => {
    try {
        const response = await axios.post<LoginResult>('https://mireaiqj.ru:8443/sign-in', data)
        thunkAPI.dispatch(setIsLogin(true))
        return thunkAPI.fulfillWithValue(response.data)
    } catch(error) {
        thunkAPI.dispatch(setIsLogin(false))
        if (axios.isAxiosError(error)) {
            const axiosError = error as AxiosError
            return thunkAPI.rejectWithValue(axiosError.message)
        }
        return thunkAPI.rejectWithValue("Unknown axios error")
    }
})