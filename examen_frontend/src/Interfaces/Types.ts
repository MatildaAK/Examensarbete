export interface UserBase {
    name: string;
    email: string;
  }
  
  export interface User extends UserBase {
    id: number;
  }
  
  export interface NewUser extends UserBase {
    id?: undefined;
  }
  