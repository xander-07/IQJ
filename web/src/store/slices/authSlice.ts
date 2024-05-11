import { createSlice } from '@reduxjs/toolkit'
import { login } from '../../api/auth'
import axios from 'axios'

interface IInitialState {
    status: 'none' | 'loading' | 'success' | 'failed'
    result: string | null
    error: string | null
}

const initialState: IInitialState = {
    status: 'none',
    result: null,
    error: null
}

const authSlice = createSlice({
    name: 'auth',
    initialState,
    reducers: {},
    extraReducers: (builder) => {
        builder.addCase(login.pending, (state, action: any) => {
            state.status = 'loading'
        }).addCase(login.fulfilled, (state, action) => {
            axios.defaults.headers["Authorization"] = `Bearer ${action.payload}`
            localStorage.setItem("token", `Bearer ${action.payload}`)
            localStorage.setItem("isLogin", "true")

            state.status = 'success'
            state.result = action.payload
        }).addCase(login.rejected, (state, action) => {
            localStorage.setItem("isLogin", "false")

            state.status = 'failed'
            state.result = null
            state.error = action.payload as string
        })
    },
})

export default authSlice.reducer