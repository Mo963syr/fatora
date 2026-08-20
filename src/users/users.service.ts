// src/users/users.service.ts
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { User, UserDocument } from './schemas/user.schema';
import { CreateUserDto } from './dto/create-user.dto';
import { LoginUserDto } from './dto/login-user.dto';

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
    const users = await this.userModel.find().exec();
    return users.map((user) => this.toPublicUser(user) as UserDocument);
  }

  async login(loginUserDto: LoginUserDto) {
    const user = await this.userModel
      .findOne({ sequentialNumber: loginUserDto.sequentialNumber })
      .exec();

    if (!user || user.password !== loginUserDto.password) {
      throw new UnauthorizedException('الرقم التسلسلي أو كلمة المرور غير صحيحة');
    }

    return this.toPublicUser(user);
  }

  async findBySequentialNumber(sequentialNumber: number) {
    const user = await this.userModel.findOne({ sequentialNumber }).exec();

    if (!user) {
      return null;
    }

    return this.toPublicUser(user);
  }

  private toPublicUser(user: UserDocument) {
    return {
      id: user._id.toString(),
      fullName: user.fullName,
      birthDate: user.birthDate,
      gender: user.gender,
      studyLevel: user.studyLevel,
      specialty: user.specialty,
      secondaryTrack: user.secondaryTrack,
      workStatus: user.workStatus,
      workType: user.workType,
      address: user.address,
      phone: user.phone,
      sequentialNumber: user.sequentialNumber,
    };
  }
}