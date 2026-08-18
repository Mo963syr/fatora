// src/users/users.service.ts
import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { User, UserDocument } from './schemas/user.schema';
import { CreateUserDto } from './dto/create-user.dto';

@Injectable()
export class UsersService {
  constructor(
    @InjectModel(User.name) 
    private userModel: Model<UserDocument>,
  ) {}

  async create(createUserDto: CreateUserDto): Promise<UserDocument> {
    // 1. استخراج سنة الميلاد من birthDate (صيغة YYYY-MM-DD)
    const birthYear = new Date(createUserDto.birthDate).getFullYear();
    
    // 2. توليد كلمة المرور: رقم الهاتف + سنة الميلاد (ملتصقين)
    const generatedPassword = `${createUserDto.phone}${birthYear}`;

    // 3. حساب الرقم التسلسلي
    const count = await this.userModel.countDocuments();
    const sequentialNumber = count + 1;

    // 4. إنشاء المستخدم
    const newUser = await this.userModel.create({
      ...createUserDto,
      password: generatedPassword,
      sequentialNumber: sequentialNumber,
    });

    return newUser;
  }

  async findAll(): Promise<UserDocument[]> {
    return this.userModel.find().exec();
  }
}