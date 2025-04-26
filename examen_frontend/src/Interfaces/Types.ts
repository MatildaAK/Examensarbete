export interface UserBase {
    user_name: string;
    email: string;
    password: string;
    name: string;
  }
  
  export interface User extends UserBase {
    id: number;
  }
  
  export interface NewUser extends UserBase {
    id?: undefined;
  }
  