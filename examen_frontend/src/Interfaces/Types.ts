export interface UserBase {
    user_name: string;
    email: string;
    password: string;
    name: string;
  }
  
  export interface User extends UserBase {
    id: string;
  }
  
  export interface NewUser extends UserBase {
    id?: string;
  }
  