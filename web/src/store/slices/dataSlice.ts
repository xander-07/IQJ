import { PayloadAction, createSlice } from "@reduxjs/toolkit"

interface IInitialState {
    isLogin: boolean
}

const initialState: IInitialState = {
    isLogin: false
}

const dataSlice = createSlice({
    name: 'data',
    initialState,
    reducers: {
        setIsLogin(state, action: PayloadAction<boolean>) {
            state.isLogin = action.payload
        }
    }
})

export const { setIsLogin } = dataSlice.actions
export default dataSlice.reducer