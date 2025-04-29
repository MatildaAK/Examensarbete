export interface HotelBase {
    name: string;
  }
  
  export interface Hotel extends HotelBase {
    hotel_rooms?: HotelRoom[];
    id: number;
  }
  
  export interface NewHotel extends HotelBase {
    id?: undefined;
  }

  export interface HotelRoomBase {
    name: string;
    size: string;
  }

  export interface HotelRoom extends HotelRoomBase {
    id: number;
  }

  export interface NewHotelRoom extends HotelRoomBase {
    id?: undefined;
  }